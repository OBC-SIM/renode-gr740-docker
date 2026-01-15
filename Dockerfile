# Pre-built RTEMS + Renode 환경 이미지를 기반으로 시작
FROM mcleroysane19/rtems-gr740-env:latest

# --------------------------------------------------------------------------
# [Optional] 추가 패키지 설치나 사용자 설정을 이곳에 작성하세요.
# 예: RUN apt-get update && apt-get install -y my-favorite-tool
# --------------------------------------------------------------------------

# 작업 디렉토리 설정 (기본값 유지)
WORKDIR /workspace

# 컨테이너 시작 시 실행할 명령
CMD ["/bin/bash"]
