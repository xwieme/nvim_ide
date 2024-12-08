FROM ubuntu:oracular

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Install development packages
RUN apt-get update -y &&\
    apt-get install -y \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    tmux \
    ripgrep \
    git &&\
    apt-get clean

# Build latest version of neovim from source and install starship
RUN git clone https://github.com/neovim/neovim &&\
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo &&\
    make install &&\
    make clean &&\
    rm -rf /neovim 

# Create non root user with same UID of local user 
ARG USER_ID 
ARG GROUP_ID

RUN userdel ubuntu &&\
    groupadd -g ${GROUP_ID} user &&\
    useradd -g user -u ${USER_ID} user &&\
    install -d -m 755 -o user -g user /home/user/.config &&\
    chown --recursive ${USER_ID}:${GROUP_ID} /home/user 

# Copy configuration folders 
COPY --chown=${USER_ID}:${GROUP_ID} nvim /home/user/.config/nvim
COPY --chown=${USER_ID}:${GROUP_ID} tmux /home/user/.config/tmux
COPY --chown=${USER_ID}:${GROUP_ID} .bashrc /home/user/.bashrc

USER ${USER_ID}
