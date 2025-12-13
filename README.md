# Renode + GR740 VSCode Debugging Environment

Renode 시뮬레이터와 GR740 SPARC 프로세서를 위한 VSCode 통합 디버깅 환경입니다.

## Prerequisites

이 환경을 사용하기 전에 다음 사항들이 준비되어야 합니다:

### 1. Required Tools

- **Docker**: Dev Container 실행을 위해 필요
- **VSCode**: Visual Studio Code
- **VSCode Extensions**:
  - Dev Containers (Microsoft)
  - C/C++ (Microsoft)
  - Command Variable (rioj7)

### 2. PROM Image

**중요**: 이 환경은 `mkprom`으로 생성된 PROM 이미지가 필요합니다.

사용자 애플리케이션을 포함한 PROM 이미지를 미리 준비해야 합니다:

1. RTEMS 애플리케이션 빌드 (`.exe` 또는 `.elf` 파일)
2. `mkprom` 또는 `mkprom2` 도구를 사용하여 PROM 이미지 생성
3. 생성된 `.prom` 파일을 프로젝트 디렉터리에 배치

예시:
```bash
cd samples/hello-world
make
# b-gr740/app.exe 생성됨

# mkprom을 사용하여 PROM 이미지 생성
mkprom2 -gr740 -baud 38400 -freq 20 b-gr740/app.exe -o b-gr740/app.prom
```

### 3. Toolchain

다음 도구들이 필요합니다 (Docker 이미지에 포함되어야 함):

- SPARC RTEMS6 GCC toolchain
- `sparc-rtems6-gdb`
- Renode simulator

## Project Structure

```
.
├── .devcontainer/          # Dev Container 설정
│   └── devcontainer.json
├── .vscode/                # VSCode 디버깅 설정
│   ├── launch.json         # 디버그 실행 설정
│   └── tasks.json          # Renode 실행 태스크
├── samples/                # 샘플 애플리케이션
│   └── hello-world/        # Hello World 예제
│       ├── hello.c
│       ├── init.c
│       ├── Makefile
│       └── b-gr740/        # 빌드 출력 (gitignore됨)
│           └── app.prom    # PROM 이미지 (필수!)
├── gr740.repl              # GR740 플랫폼 정의
├── main.resc               # Renode 시작 스크립트
├── Dockerfile              # 개발 환경 Docker 이미지
└── setup-renode.sh         # Renode 설정 스크립트
```

## Getting Started

### 1. Dev Container 시작

1. VSCode에서 프로젝트 폴더 열기
2. Command Palette (`Ctrl+Shift+P` 또는 `Cmd+Shift+P`)에서 "Dev Containers: Reopen in Container" 실행
3. 컨테이너가 빌드되고 시작됨

### 2. 샘플 애플리케이션 빌드

```bash
cd samples/hello-world
make
```

빌드 후 `b-gr740/` 디렉터리에 다음 파일들이 생성됩니다:
- `app.exe`: 실행 파일
- `app.prom`: PROM 이미지 (mkprom으로 생성 필요)

### 3. 디버깅 시작

1. VSCode에서 디버그 뷰 열기 (`Ctrl+Shift+D` 또는 `Cmd+Shift+D`)
2. "Debug application in Renode" 설정 선택
3. `F5` 키를 눌러 디버깅 시작
4. 디버그할 `.exe` 또는 `.elf` 파일 선택
5. Renode가 자동으로 시작되고 GDB 서버가 포트 3333에서 실행됨

## Configuration Files

### gr740.repl

GR740 프로세서의 하드웨어 플랫폼 정의:
- Memory mapping (ROM, SDRAM, SRAM)
- Peripherals (UART, Timer, GPIO, Ethernet 등)
- Interrupt controller
- Big-endian SPARC/Leon3 CPU

### main.resc

Renode 시작 스크립트:
- 플랫폼 로드
- PROM 이미지 로드
- UART 분석기 표시
- GDB 서버 시작 (포트 3333)

기본 설정:
```
$bin = @/opt/samples/hello-world/b-gr740/app.prom
```

다른 PROM 이미지를 사용하려면 이 경로를 수정하세요.

## Debugging Workflow

1. **Pre-Launch**: VSCode가 자동으로 "Run Renode" 태스크 실행
2. **Renode 시작**: `main.resc` 스크립트로 시뮬레이터 시작
3. **GDB 연결**: GDB가 localhost:3333으로 연결
4. **디버깅**: VSCode에서 중단점 설정, 변수 검사, 단계별 실행 등
5. **Post-Debug**: 디버깅 종료 시 Renode 자동 종료

## Troubleshooting

### PROM 이미지 오류

```
Error: Could not load file: .../app.prom
```

**해결 방법**: `mkprom` 또는 `mkprom2`로 PROM 이미지를 생성했는지 확인하세요.

### GDB 연결 실패

```
Unable to connect to localhost:3333
```

**해결 방법**:
1. Renode 태스크가 정상적으로 실행되었는지 확인
2. Terminal에서 "GDB server with all CPUs started on port" 메시지 확인
3. 포트 3333이 다른 프로세스에 의해 사용되고 있지 않은지 확인

### mkprom 사용법

```bash
# 기본 사용법
mkprom2 -gr740 -baud 38400 -freq 20 <input.exe> -o <output.prom>

# 예시
mkprom2 -gr740 -baud 38400 -freq 20 b-gr740/app.exe -o b-gr740/app.prom
```

주요 옵션:
- `-gr740`: GR740 타겟 지정
- `-baud 38400`: UART 보드레이트
- `-freq 20`: 클럭 주파수 (MHz)

## References

- [Renode Documentation](https://renode.readthedocs.io/)
- [GR740 Quad Core LEON4 Processor](https://www.gaisler.com/index.php/products/processors/gr740)
- [RTEMS Documentation](https://docs.rtems.org/)
- mkprom2 Documentation: `mkprom2/doc/mkprom2.pdf`

## License

해당 프로젝트의 라이선스를 여기에 명시하세요.
