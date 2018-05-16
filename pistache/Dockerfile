FROM ubuntu:18.04

RUN useradd --create-home user -G sudo && \
    echo user":rootpw" | chpasswd
USER user
WORKDIR /home/user

EXPOSE 8080
ENV PORT 8080

COPY pistache-demo ./
CMD ["./pistache-demo"]