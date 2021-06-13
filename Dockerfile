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
 apt-get install -y locales-all
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
pip install -r requirements.txt




# フォントの設定。Dockerfileと同じ場所にIPAフォントを配置しておく。
# https://moji.or.jp/ipafont/ipafontdownload/
RUN mkdir -p /root/.fonts
ADD ipaexg.ttf /root/.fonts/.
ADD ipaexm.ttf /root/.fonts/.


# Define default command.
CMD ["/bin/bash"]
