#!/bin/bash

# Flutter 개발 도구 스크립트
# OpenHands Flutter Development Tools

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
        echo "  ./.openhands/dev-tools.sh [명령어]"
        echo ""
        print_warning "만약 .openhands 디렉토리 안에서 실행하고 있다면, 상위 디렉토리로 이동하세요:"
        echo "  cd .."
        echo "  ./.openhands/dev-tools.sh [명령어]"
        exit 1
    fi
}

# 도움말 출력
show_help() {
    echo "Flutter 개발 도구 스크립트"
    echo ""
    echo "사용법: $0 [명령어]"
    echo ""
    echo "명령어:"
    echo "  setup       - 개발 환경 설정"
    echo "  clean       - 프로젝트 정리"
    echo "  build       - 앱 빌드"
    echo "  test        - 테스트 실행"
    echo "  analyze     - 코드 분석"
    echo "  format      - 코드 포맷팅"
    echo "  run-web     - 웹에서 앱 실행"
    echo "  run-mobile  - 모바일에서 앱 실행"
    echo "  doctor      - Flutter Doctor 실행"
    echo "  deps        - 의존성 업데이트"
    echo "  gen         - 코드 생성"
    echo "  help        - 도움말 출력"
    echo ""
}

# 프로젝트 정리
clean_project() {
    print_status "프로젝트를 정리합니다..."
    
    flutter clean
    flutter pub get
    
    # 빌드 캐시 정리
    if [ -d "build" ]; then
        rm -rf build
        print_status "build 폴더를 삭제했습니다."
    fi
    
    # iOS 관련 정리 (macOS에서만)
    if [[ "$OSTYPE" == "darwin"* ]] && [ -d "ios" ]; then
        cd ios
        if [ -f "Podfile" ]; then
            pod clean 2>/dev/null || true
            rm -rf Pods 2>/dev/null || true
            rm -f Podfile.lock 2>/dev/null || true
        fi
        cd ..
    fi
    
    print_success "프로젝트 정리가 완료되었습니다."
}

# 앱 빌드
build_app() {
    local platform=${1:-"all"}
    
    print_status "앱을 빌드합니다 (플랫폼: $platform)..."
    
    case $platform in
        web)
            flutter build web
            ;;
        android)
            flutter build apk
            ;;
        ios)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                flutter build ios
            else
                print_error "iOS 빌드는 macOS에서만 가능합니다."
                return 1
            fi
            ;;
        all)
            flutter build web
            flutter build apk
            if [[ "$OSTYPE" == "darwin"* ]]; then
                flutter build ios
            fi
            ;;
        *)
            print_error "지원하지 않는 플랫폼입니다: $platform"
            print_status "지원 플랫폼: web, android, ios, all"
            return 1
            ;;
    esac
    
    print_success "빌드가 완료되었습니다."
}

# 테스트 실행
run_tests() {
    print_status "테스트를 실행합니다..."
    
    if [ ! -d "test" ] || [ -z "$(ls -A test 2>/dev/null)" ]; then
        print_warning "테스트 파일이 없습니다."
        return 0
    fi
    
    # 단위 테스트 실행
    flutter test
    
    # 통합 테스트가 있다면 실행
    if [ -d "integration_test" ] && [ -n "$(ls -A integration_test 2>/dev/null)" ]; then
        print_status "통합 테스트를 실행합니다..."
        flutter test integration_test
    fi
    
    print_success "테스트가 완료되었습니다."
}

# 코드 분석
analyze_code() {
    print_status "코드 분석을 실행합니다..."
    
    flutter analyze --fatal-infos
    
    if [ $? -eq 0 ]; then
        print_success "코드 분석이 완료되었습니다."
    else
        print_error "코드 분석에서 문제가 발견되었습니다."
        return 1
    fi
}

# 코드 포맷팅
format_code() {
    print_status "코드 포맷팅을 실행합니다..."
    
    dart format .
    
    print_success "코드 포맷팅이 완료되었습니다."
}

# 웹에서 앱 실행
run_web() {
    local port=${1:-12000}
    
    print_status "웹에서 앱을 실행합니다 (포트: $port)..."
    
    flutter run -d web-server --web-port=$port --web-hostname=0.0.0.0
}

# 모바일에서 앱 실행
run_mobile() {
    print_status "연결된 디바이스를 확인합니다..."
    
    flutter devices
    
    print_status "모바일에서 앱을 실행합니다..."
    flutter run
}

# Flutter Doctor 실행
run_doctor() {
    print_status "Flutter Doctor를 실행합니다..."
    
    flutter doctor -v
}

# 의존성 업데이트
update_dependencies() {
    print_status "의존성을 업데이트합니다..."
    
    # 현재 의존성 상태 확인
    flutter pub outdated
    
    # 의존성 업데이트
    flutter pub upgrade
    
    print_success "의존성 업데이트가 완료되었습니다."
}

# 코드 생성
generate_code() {
    print_status "코드 생성을 실행합니다..."
    
    # build_runner가 있는지 확인
    if grep -q "build_runner" pubspec.yaml; then
        flutter packages pub run build_runner build --delete-conflicting-outputs
        print_success "코드 생성이 완료되었습니다."
    else
        print_warning "build_runner가 설정되어 있지 않습니다."
        print_status "코드 생성이 필요한 경우 pubspec.yaml에 build_runner를 추가해주세요."
    fi
}

# 메인 함수
main() {
    local command=${1:-"help"}
    
    # 프로젝트 루트 디렉토리 확인 (help 명령어는 제외)
    if [ "$command" != "help" ] && [ "$command" != "--help" ] && [ "$command" != "-h" ]; then
        check_project_root
    fi
    
    case $command in
        setup)
            .openhands/setup.sh
            ;;
        clean)
            clean_project
            ;;
        build)
            build_app $2
            ;;
        test)
            run_tests
            ;;
        analyze)
            analyze_code
            ;;
        format)
            format_code
            ;;
        run-web)
            run_web $2
            ;;
        run-mobile)
            run_mobile
            ;;
        doctor)
            run_doctor
            ;;
        deps)
            update_dependencies
            ;;
        gen)
            generate_code
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "알 수 없는 명령어입니다: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 스크립트 실행
main "$@"