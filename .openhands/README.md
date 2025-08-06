# OpenHands Flutter Development Tools

Flutter 앱 개발을 위한 자동화된 개발 환경 설정 및 도구 모음입니다.

## 📁 파일 구조

```
.openhands/
├── setup.sh           # 개발 환경 초기 설정 스크립트
├── pre-commit.sh       # Pre-commit 검증 스크립트
├── dev-tools.sh        # 개발 도구 통합 스크립트
└── README.md          # 이 파일
```

## 🚀 빠른 시작

### 1. 개발 환경 설정

```bash
# 실행 권한 부여
chmod +x .openhands/*.sh

# 개발 환경 설정
./.openhands/setup.sh
```

### 2. Pre-commit Hook 설정

```bash
# pre-commit 설치 (Python 환경 필요)
pip install pre-commit

# pre-commit hook 설치
pre-commit install

# 수동으로 pre-commit 실행
pre-commit run --all-files
```

## 🛠️ 스크립트 상세 설명

### setup.sh - 개발 환경 설정

Flutter 개발에 필요한 모든 환경을 자동으로 설정합니다.

**주요 기능:**
- Flutter SDK 설치 확인 및 설치
- 프로젝트 의존성 설치 (`flutter pub get`)
- Pre-commit 도구 설치
- Git hooks 설정
- Flutter Doctor 실행
- 프로젝트 검증 (분석 + 테스트)

**사용법:**
```bash
./.openhands/setup.sh
```

### pre-commit.sh - Pre-commit 검증

커밋 전에 코드 품질을 자동으로 검사합니다.

**주요 기능:**
- 코드 포맷팅 검사 및 자동 수정 (`dart format`)
- 코드 분석 (`flutter analyze`)
- 테스트 실행 (`flutter test`)
- 의존성 검사 (pubspec.yaml 변경 시)
- 파일 크기 검사 (1MB 이상 파일 경고)

**자동 실행:**
- Git commit 시 자동으로 실행됩니다.

**수동 실행:**
```bash
./.openhands/pre-commit.sh
```

### dev-tools.sh - 개발 도구 통합

Flutter 개발에 필요한 다양한 명령어를 통합 제공합니다.

**사용법:**
```bash
./.openhands/dev-tools.sh [명령어]
```

**사용 가능한 명령어:**

| 명령어 | 설명 | 예시 |
|--------|------|------|
| `setup` | 개발 환경 설정 | `./dev-tools.sh setup` |
| `clean` | 프로젝트 정리 | `./dev-tools.sh clean` |
| `build` | 앱 빌드 | `./dev-tools.sh build web` |
| `test` | 테스트 실행 | `./dev-tools.sh test` |
| `analyze` | 코드 분석 | `./dev-tools.sh analyze` |
| `format` | 코드 포맷팅 | `./dev-tools.sh format` |
| `run-web` | 웹에서 앱 실행 | `./dev-tools.sh run-web 12000` |
| `run-mobile` | 모바일에서 앱 실행 | `./dev-tools.sh run-mobile` |
| `doctor` | Flutter Doctor 실행 | `./dev-tools.sh doctor` |
| `deps` | 의존성 업데이트 | `./dev-tools.sh deps` |
| `gen` | 코드 생성 | `./dev-tools.sh gen` |
| `help` | 도움말 출력 | `./dev-tools.sh help` |

## 📋 Pre-commit 설정 (.pre-commit-config.yaml)

프로젝트에는 다음과 같은 pre-commit hooks가 설정되어 있습니다:

### Flutter/Dart 관련
- **flutter-pre-commit**: 커스텀 Flutter 검증 스크립트
- **dart-format**: Dart 코드 포맷팅
- **flutter-analyze**: Flutter 코드 분석

### 일반 파일 검사
- **end-of-file-fixer**: 파일 끝 개행 확인
- **trailing-whitespace**: 불필요한 공백 제거
- **check-added-large-files**: 큰 파일 검사 (10MB 제한)
- **check-yaml**: YAML 문법 검사
- **check-json**: JSON 문법 검사
- **check-merge-conflict**: 병합 충돌 마커 검사

### 커밋 메시지 검사
- **conventional-pre-commit**: 컨벤셔널 커밋 메시지 검사

## 🌐 웹 개발 서버 실행

OpenHands 환경에서 웹 앱을 실행할 때:

```bash
# 포트 12000에서 실행 (기본값)
./.openhands/dev-tools.sh run-web

# 다른 포트에서 실행
./.openhands/dev-tools.sh run-web 12001
```

접속 URL:
- https://work-1-hjceoppiisirqcjy.prod-runtime.all-hands.dev (포트 12000)
- https://work-2-hjceoppiisirqcjy.prod-runtime.all-hands.dev (포트 12001)

## 🔧 커스터마이징

### 새로운 검사 추가

`pre-commit.sh`에 새로운 검사 함수를 추가하고 `main()` 함수에서 호출하세요.

### 새로운 개발 도구 추가

`dev-tools.sh`에 새로운 함수를 추가하고 `main()` 함수의 case 문에 추가하세요.

### Pre-commit Hook 수정

`.pre-commit-config.yaml` 파일을 수정하여 새로운 hook을 추가하거나 기존 설정을 변경하세요.

## 🐛 문제 해결

### Flutter SDK를 찾을 수 없는 경우
```bash
# PATH에 Flutter 추가
export PATH="$PATH:/opt/flutter/bin"

# 또는 ~/.bashrc에 영구적으로 추가
echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
```

### Pre-commit이 실행되지 않는 경우
```bash
# pre-commit 재설치
pre-commit uninstall
pre-commit install

# 권한 확인
chmod +x .openhands/pre-commit.sh
```

### 의존성 문제
```bash
# 캐시 정리 후 재설치
flutter clean
flutter pub get
```

## 📝 커밋 메시지 컨벤션

다음 형식을 따라 커밋 메시지를 작성하세요:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Type:**
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 스타일 변경 (포맷팅, 세미콜론 등)
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가 또는 수정
- `chore`: 빌드 프로세스 또는 도구 변경

**예시:**
```
feat(auth): 사용자 로그인 기능 추가

Google OAuth를 사용한 소셜 로그인 기능을 구현했습니다.

Closes #123
```

## 🤝 기여하기

1. 이슈를 생성하여 문제나 개선사항을 제안하세요.
2. 브랜치를 생성하고 변경사항을 커밋하세요.
3. Pre-commit 검사가 통과하는지 확인하세요.
4. Pull Request를 생성하세요.

## 📄 라이선스

이 도구들은 MIT 라이선스 하에 제공됩니다.