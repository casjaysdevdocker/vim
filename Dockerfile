FROM alpine:edge as build

RUN apk --no-cache add --update \
  vim \
  bash \
  curl \
  ca-certificates \
  git \
  tmux \
  util-linux \
  pciutils \
  usbutils \
  coreutils \
  binutils \
  findutils \
  grep \
  iproute2 && \
  ln -sf /bin/bash /bin/sh && \
  mkdir -p /root/.vim/autoload /root/.vim/bundle /root/.cache/resurrect 

COPY ./config/resurrect/ /root/.cache/resurrect/
COPY ./config/tmux.conf /config/.tmux.conf
COPY ./config/bashrc /config/.bashrc
COPY ./config/vimrc /config/.vimrc
COPY ./bin/. /usr/local/bin/

RUN /usr/local/bin/tmux-plugins \
  curl -q -LSsf -o ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
  vim -u "/config/.vimrc" -c ":BundleInstall" +qall </dev/null &>/dev/null && \
  vim -u "/config/.vimrc" -c ":PluginInstall" +qall </dev/null &>/dev/null && \
  vim -u "/config/.vimrc" -c ":PluginClean" +qall </dev/null &>/dev/null 

FROM scratch

ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')" 

LABEL \
  org.label-schema.name="vim" \
  org.label-schema.description="vim text editor" \
  org.label-schema.url="https://github.com/casjaysdev/vim" \
  org.label-schema.vcs-url="https://github.com/casjaysdev/vim" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="MIT" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>" 

ENV VIM_INDENT="2" \
  VIMRC="/root/.vimrc" \
  SHELL="/bin/bash" \
  TERM="xterm-256color" \
  HOSTNAME="casjaysdev-vim" \
  TZ="${TZ:-America/New_York}"

WORKDIR /root
VOLUME ["/root","/config"]

COPY --from=build /. /

HEALTHCHECK CMD [ "/usr/local/bin/entrypoint-vim.sh", "healthcheck" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint-vim.sh" ]
CMD [ "/usr/bin/tmux" ]
