# Renode + GR740 VSCode Debugging Environment

Renode 시뮬레이터와 GR740 SPARC 프로세서를 위한 VSCode 통합 디버깅 환경입니다.
**RTEMS 6 툴체인과 Renode 시뮬레이터가 포함된 사전 빌드된 Docker 이미지**를 사용하여, 복잡한 설치 과정 없이 즉시 개발을 시작할 수 있습니다.

## Prerequisites

이 환경을 사용하기 위해 다음 도구들이 필요합니다:

### 0. System Requirements

원활한 Dev Container 빌드 및 실행을 위해 호스트 PC에 **최소 20GB 이상의 디스크 여유 공간**이 필요합니다.

### 1. Host Tools

* **Docker Desktop**: Dev Container 실행을 위해 필요
* **VSCode**: Visual Studio Code
* **VSCode Extensions**:
* Dev Containers (Microsoft)
* C/C++ (Microsoft)


### 2. X Server (Windows Only)

Renode의 GUI 창을 띄우기 위해 Windows 사용자는 **VcXsrv (XLaunch)**가 필요합니다.

1. [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/) 다운로드 및 설치
2. **XLaunch 실행 및 설정 (중요)**:
* **Display settings**: `Multiple windows` 선택 (Display number는 -1)
* **Client startup**: `Start no client` 선택
* **Extra settings**: **`Disable access control` 체크 필수** (이걸 체크 안 하면 Docker에서 접속이 차단됨)
* **Finish**: 설정 저장 후 실행


3. 방화벽 경고가 뜨면 `Public/Private` 네트워크 모두 **허용**

## Dev Container Setup

이 프로젝트는 두 가지 방식의 개발 환경 구성을 지원합니다.

### Option A: Pre-built Image (기본값, 권장)

* **설정 파일**: `.devcontainer/devcontainer.json`
* **특징**: `mcleroysane19/rtems-gr740-env:latest` 이미지를 다운로드하여 즉시 사용합니다.
* **사용법**: VSCode에서 `Ctrl + Shift + P` > `Dev Containers: Reopen in Container` 선택 시 기본으로 이 설정이 사용됩니다.

### Option B: Build from Dockerfile (사용자 정의)

* **설정 파일**: `.devcontainer/devcontainer_build.json`
* **특징**: 로컬 `Dockerfile`을 기반으로 이미지를 새로 빌드합니다. 추가 패키지 설치 등 환경 커스터마이징이 필요할 때 사용합니다.
* **사용법**:
1. `.devcontainer/devcontainer.json`의 이름을 변경하거나 삭제합니다.
2. `devcontainer_build.json`의 이름을 `devcontainer.json`으로 변경합니다.
3. VSCode에서 `Dev Containers: Reopen in Container`를 실행하면 Dockerfile 기반으로 빌드가 진행됩니다.



## Project Core Structure

```text
.
├── .devcontainer/
│   ├── devcontainer.json        # (기본) Pre-built 이미지 사용 설정
│   └── devcontainer_build.json  # (옵션) Dockerfile 빌드 모드 설정
├── .vscode/                     # VSCode 디버깅 설정
│   ├── launch.json
│   └── tasks.json
├── samples/                     # 샘플 애플리케이션
│   └── hello-world/
│       ├── Makefile
│       └── b-gr740/             # 빌드 결과물 (app.prom 등)
├── gr740.repl                   # 하드웨어 정의
├── main.resc                    # Renode 스크립트
├── Dockerfile                   # 사용자 정의용 템플릿 (옵션 B에서 사용)
└── config.ini

```

> **Note**: 프로젝트 마운트 경로는 `/workspace`입니다. 소스 코드 경로는 반드시 `/workspace`로 시작해야 합니다.

## Getting Started

### 1. 환경 실행

VSCode에서 프로젝트를 열고 좌측 하단의 `><` 아이콘을 클릭하거나 `Ctrl + Shift + P`을 눌러 **"Reopen in Container"**를 실행합니다.

### 2. 샘플 빌드 & 디버깅

1. **빌드**: 터미널에서 샘플 폴더로 이동하여 빌드합니다.
```bash
cd samples/hello-world
make
```

2. **GUI 준비**: 호스트 PC에서 **XLaunch**가 실행 중인지 확인합니다.
3. **디버깅**: `F5` 키를 눌러 **"Debug application in Renode"**를 실행하고, 생성된 `app.exe` 파일을 선택합니다.

## Configuration Files

### main.resc (경로 주의)

스크립트 내 경로는 컨테이너 내부 경로인 `/workspace`를 사용해야 합니다.

```bash
$name?="gr740"
$bin?=@/workspace/samples/hello-world/b-gr740/app.prom
$repl?=@/workspace/gr740.repl
...
```

## Troubleshooting

### Renode GUI 오류

`Error: Can't open display: host.docker.internal:0.0` 오류 발생 시:

1. XLaunch가 실행 중인지 확인하세요.
2. XLaunch 설정 시 `Disable access control`을 체크했는지 확인하세요.

### GDB 연결 실패

`Unable to connect to localhost:3333` 오류 발생 시:

1. 터미널 탭에서 Renode 실행 로그를 확인하세요.
2. 포트 3333이 다른 프로세스에 점유되어 있는지 확인하세요.

## Changelog

### [2026-01-15] - Environment Optimization

**Added**

* **Pre-built Image Support**: Docker Hub에 이미지로 배포하는 방식을 사용하여 초기 설정 시간을 단축했습니다.
* **XLaunch Guide**: Windows GUI 지원 가이드 추가.

**Changed**

* **Dual DevContainer Config**: `devcontainer.json`(이미지 모드)과 `devcontainer_build.json`(빌드 모드)으로 설정 분리.
* **Dockerfile**: 사용자 커스터마이징을 위한 경량 템플릿 구조로 변경.
* **Mount Path**: 툴체인 보호를 위해 워크스페이스 경로를 `/opt` → `/workspace`로 변경.

## License

본 프로젝트는 Apache License 2.0에 따라 라이선스가 부여됩니다.
