FROM ubuntu:20.10



# 環境変数設定
ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG ja_JP.UTF-8
ENV PYTHONIOENCODIND utf_8

# 色々とインストール
RUN \
 apt-get update && \
 apt-get install -y python3.8 curl wget unzip python3.8-distutils gnupg sudo apt-utils tzdata && \
 wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
 wget -q -O - https://linux.kite.com/dls/linux/current &&\
 echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
 apt-get update && \
 apt-get install -y python3-dev && \
 apt-get install -y google-chrome-stable && \
 curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
 rm -f /usr/bin/python /usr/bin/python3 && \
 ln /usr/bin/python3.8 /usr/bin/python && \
 ln /usr/bin/python3.8 /usr/bin/python3 && \
 python3 get-pip.py && \
 rm -f get-pip.py && \
 apt-get install -y language-pack-ja-base language-pack-ja && \
 locale-gen ja_JP.UTF-8 &&\
 apt-get install -y  gcc &&  \
 apt-get install -y g++  && \
 apt-get install -y  language-pack-ja && \
 update-locale LANG=ja_JP.UTF-8 && \
 apt-get install -y locales-all && \
 apt-get install -y vim 
#追加でgitもインストール
RUN apt-get install -y git

# プロジェクトフォルダを指定
RUN mkdir /work_dir

# requirements.txt をコンテナにコピー
ADD requirements.txt ./

#パッケージをインストール
# ここはchromeのバージョンに合わせて変える。
RUN pip install --upgrade pip && \
#pip install requests bs4 pandas jupyter jupytext selenium openpyxl &&\
#pip install chromedriver-binary==90.0.4430.24.0

#いちいちpipすべてインストールしてると時間かかるので
pip install -r requirements.txt

ADD 00_init.ipy ./.ipython/profile_default/


# フォントの設定。Dockerfileと同じ場所にIPAフォントを配置しておく。
# https://moji.or.jp/ipafont/ipafontdownload/
RUN mkdir -p /root/.fonts
ADD ipaexg.ttf /root/.fonts/.
ADD ipaexm.ttf /root/.fonts/.

ADD config /.ssh/


CMD touch /.ssh/known_hosts && \
    ssh-keyscan github.com >> /.ssh/known_hosts && \
    cd work_dir && \
    # ssh -o StrictHostKeyChecking=no -vT git@github.com && \
    git clone -o StrictHostKeyChecking=no  git@github.com:keisuke611/fashion_collaboration_analysis.git && \
    git config --global user.email s.m.keisuke0611@gmail.com && \
    git config --global user.name keisuke611 && \
    git commit --allow-empty -m 'first commit' && \
    git push --set-upstream origin master && \
    jupyter lab --NotebookApp.token='keisuke423' --ip=0.0.0.0 --no-browser --allow-root && \

#WORKDIR work_dir/fashion_collaboration_analysis/


#まずgitのssh-addが渡っていないといけないので,composeのenvのあとにやりたい
#毎回やる必要はない。runのときだけやりたい。この場合composeとDockerfileどっちに書くのがいいのか


#dockerコンテナ内にsshaddが飛んで無いので無理
#CMD git config --global user.email s.m.keisuke0611@gmail.com && \
#	git config --global user.name keisuke611 && \
#	git commit --allow-empty -m 'first commit' && \
#	git push --set-upstream origin master && \
#   jupyter lab --NotebookApp.token='keisuke423' --ip=0.0.0.0 --no-browser --allow-root && \
#    ["/bin/bash"]


#サーバー側で最後のpushしておけばこれでいけるはず。

#CMD git pull 

#CMD ["/bin/bash"]


# Define default command.
#CMD ["/bin/bash"]


#RUN jupyter lab  --NotebookApp.token='keisuke423' --ip=0.0.0.0 --no-browser --allow-root
