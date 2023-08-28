FROM mcr.microsoft.com/powershell:lts-7.2-ubuntu-20.04

RUN apt-get update -y

CMD ["echo", "Hello World...!"]