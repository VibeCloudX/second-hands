#!/bin/bash

# Flutter 앱 개발 환경 설정 스크립트
# OpenHands Flutter Development Setup Script

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수 정의
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 프로젝트 루트 디렉토리 확인
check_project_root() {
    if [ ! -f "pubspec.yaml" ] || [ ! -d ".openhands" ]; then
        print_error "이 스크립트는 Flutter 프로젝트의 루트 디렉토리에서 실행해야 합니다."
        print_error "현재 위치: $(pwd)"
        echo ""
        print_status "올바른 실행 방법:"
        echo "  cd /path/to/your/flutter/project"
        echo "  ./.openhands/setup.sh"
        echo ""
        print_warning "만약 .openhands 디렉토리 안에서 실행하고 있다면, 상위 디렉토리로 이동하세요:"
        echo "  cd .."
        echo "  ./.openhands/setup.sh"
        exit 1
    fi
}

echo "🚀 Flutter 개발 환경 설정을 시작합니다..."

# 프로젝트 루트 디렉토리 확인
check_project_root

# Flutter SDK 설치 확인
check_flutter() {
    print_status "Flutter SDK 설치 상태를 확인합니다..."
    
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter가 이미 설치되어 있습니다: $FLUTTER_VERSION"
        return 0
    else
        print_warning "Flutter SDK가 설치되어 있지 않습니다."
        return 1
    fi
}

# Flutter SDK 설치
install_flutter() {
    print_status "Flutter SDK를 설치합니다..."
    
    # 운영체제 확인
    OS=$(uname -s)
    case $OS in
        Linux*)
            print_status "Linux 환경에서 Flutter를 설치합니다..."
            cd /tmp
            wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
            tar xf flutter_linux_3.24.3-stable.tar.xz
            sudo mv flutter /opt/
            echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
            export PATH="$PATH:/opt/flutter/bin"
            ;;
        Darwin*)
            print_status "macOS 환경에서 Flutter를 설치합니다..."
            if command -v brew &> /dev/null; then
                brew install --cask flutter
            else
                print_error "Homebrew가 설치되어 있지 않습니다. 수동으로 Flutter를 설치해주세요."
                exit 1
            fi
            ;;
        *)
            print_error "지원하지 않는 운영체제입니다: $OS"
            exit 1
            ;;
    esac
    
    print_success "Flutter SDK 설치가 완료되었습니다."
}

# 의존성 설치
install_dependencies() {
    print_status "Flutter 의존성을 설치합니다..."
    
    if [ -f "pubspec.yaml" ]; then
        flutter pub get
        print_success "의존성 설치가 완료되었습니다."
    else
        print_error "pubspec.yaml 파일을 찾을 수 없습니다."
        exit 1
    fi
}

# 개발 도구 설정
setup_dev_tools() {
    print_status "개발 도구를 설정합니다..."
    
    # pre-commit 설치 (Python 환경에서)
    if command -v pip3 &> /dev/null; then
        pip3 install pre-commit
        print_success "pre-commit이 설치되었습니다."
    elif command -v pip &> /dev/null; then
        pip install pre-commit
        print_success "pre-commit이 설치되었습니다."
    else
        print_warning "pip가 설치되어 있지 않아 pre-commit을 설치할 수 없습니다."
    fi
    
    # Git hooks 설정
    if [ -f ".pre-commit-config.yaml" ]; then
        if command -v pre-commit &> /dev/null; then
            pre-commit install
            print_success "Git hooks가 설정되었습니다."
        fi
    fi
}

# Flutter Doctor 실행
run_flutter_doctor() {
    print_status "Flutter Doctor를 실행합니다..."
    flutter doctor
}

# 프로젝트 검증
validate_project() {
    print_status "프로젝트를 검증합니다..."
    
    # 코드 분석
    flutter analyze
    
    # 테스트 실행
    if [ -d "test" ] && [ "$(ls -A test)" ]; then
        print_status "테스트를 실행합니다..."
        flutter test
    else
        print_warning "테스트 파일이 없습니다."
    fi
    
    print_success "프로젝트 검증이 완료되었습니다."
}

# 메인 실행 함수
main() {
    echo "======================================"
    echo "🔧 Flutter 개발 환경 설정"
    echo "======================================"
    
    # Flutter 설치 확인 및 설치
    if ! check_flutter; then
        install_flutter
    fi
    
    # 의존성 설치
    install_dependencies
    
    # 개발 도구 설정
    setup_dev_tools
    
    # Flutter Doctor 실행
    run_flutter_doctor
    
    # 프로젝트 검증
    validate_project
    
    echo "======================================"
    print_success "🎉 Flutter 개발 환경 설정이 완료되었습니다!"
    echo "======================================"
    
    echo ""
    echo "다음 명령어로 앱을 실행할 수 있습니다:"
    echo "  flutter run"
    echo ""
    echo "개발 서버를 웹에서 실행하려면:"
    echo "  flutter run -d web-server --web-port=12000 --web-hostname=0.0.0.0"
    echo ""
}

# 스크립트 실행
main "$@"