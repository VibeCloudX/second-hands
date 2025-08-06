#!/bin/bash

# Flutter Pre-commit Hook Script
# OpenHands Flutter Pre-commit Validation

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수 정의
print_status() {
    echo -e "${BLUE}[PRE-COMMIT]${NC} $1"
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

# 변경된 Dart 파일 확인
get_changed_dart_files() {
    git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' || true
}

# 코드 포맷팅 검사 및 수정
check_and_format_code() {
    print_status "코드 포맷팅을 검사합니다..."
    
    local dart_files=$(get_changed_dart_files)
    
    if [ -z "$dart_files" ]; then
        print_status "변경된 Dart 파일이 없습니다."
        return 0
    fi
    
    # dart format 실행
    echo "$dart_files" | xargs dart format --set-exit-if-changed
    
    if [ $? -ne 0 ]; then
        print_warning "코드 포맷팅이 필요합니다. 자동으로 수정합니다..."
        echo "$dart_files" | xargs dart format
        
        # 포맷팅된 파일들을 다시 스테이징
        echo "$dart_files" | xargs git add
        
        print_success "코드 포맷팅이 완료되었습니다."
    else
        print_success "코드 포맷팅이 올바릅니다."
    fi
}

# 코드 분석
analyze_code() {
    print_status "코드 분석을 실행합니다..."
    
    flutter analyze --fatal-infos
    
    if [ $? -eq 0 ]; then
        print_success "코드 분석이 통과되었습니다."
    else
        print_error "코드 분석에서 문제가 발견되었습니다."
        return 1
    fi
}

# 테스트 실행
run_tests() {
    print_status "테스트를 실행합니다..."
    
    # 테스트 파일이 있는지 확인
    if [ ! -d "test" ] || [ -z "$(ls -A test 2>/dev/null)" ]; then
        print_warning "테스트 파일이 없습니다. 테스트를 건너뜁니다."
        return 0
    fi
    
    # 변경된 파일과 관련된 테스트가 있는지 확인
    local dart_files=$(get_changed_dart_files)
    local has_lib_changes=false
    
    if echo "$dart_files" | grep -q "^lib/"; then
        has_lib_changes=true
    fi
    
    # lib 폴더에 변경사항이 있거나 테스트 파일이 변경된 경우에만 테스트 실행
    if [ "$has_lib_changes" = true ] || echo "$dart_files" | grep -q "^test/"; then
        flutter test
        
        if [ $? -eq 0 ]; then
            print_success "모든 테스트가 통과되었습니다."
        else
            print_error "테스트가 실패했습니다."
            return 1
        fi
    else
        print_status "라이브러리 코드 변경이 없어 테스트를 건너뜁니다."
    fi
}

# 의존성 검사
check_dependencies() {
    print_status "의존성을 검사합니다..."
    
    # pubspec.yaml이 변경되었는지 확인
    if git diff --cached --name-only | grep -q "pubspec.yaml"; then
        print_status "pubspec.yaml이 변경되었습니다. 의존성을 업데이트합니다..."
        flutter pub get
        
        # pubspec.lock도 커밋에 포함
        if [ -f "pubspec.lock" ]; then
            git add pubspec.lock
            print_success "pubspec.lock이 업데이트되었습니다."
        fi
    fi
}

# 커밋 메시지 검증 (선택사항)
validate_commit_message() {
    # 이 함수는 commit-msg hook에서 사용될 수 있습니다
    local commit_msg_file="$1"
    
    if [ -f "$commit_msg_file" ]; then
        local commit_msg=$(cat "$commit_msg_file")
        
        # 커밋 메시지 길이 검사 (50자 이하 권장)
        local subject_line=$(echo "$commit_msg" | head -n 1)
        if [ ${#subject_line} -gt 72 ]; then
            print_warning "커밋 메시지 제목이 72자를 초과합니다: ${#subject_line}자"
        fi
        
        # 커밋 메시지 패턴 검사 (선택사항)
        # 예: feat:, fix:, docs:, style:, refactor:, test:, chore: 등
        if ! echo "$subject_line" | grep -qE "^(feat|fix|docs|style|refactor|test|chore|build|ci|perf|revert)(\(.+\))?: .+"; then
            print_warning "커밋 메시지가 컨벤션을 따르지 않습니다. 예: 'feat: 새로운 기능 추가'"
        fi
    fi
}

# 파일 크기 검사
check_file_sizes() {
    print_status "파일 크기를 검사합니다..."
    
    local large_files=$(git diff --cached --name-only | xargs -I {} sh -c 'if [ -f "{}" ]; then echo "$(stat -f%z "{}" 2>/dev/null || stat -c%s "{}" 2>/dev/null) {}"; fi' | awk '$1 > 1048576 {print $2 " (" $1 " bytes)"}')
    
    if [ -n "$large_files" ]; then
        print_warning "큰 파일이 감지되었습니다 (1MB 이상):"
        echo "$large_files"
        print_warning "큰 파일을 커밋하기 전에 정말 필요한지 확인해주세요."
    fi
}

# 메인 실행 함수
main() {
    echo "======================================"
    echo "🔍 Flutter Pre-commit 검사 시작"
    echo "======================================"
    
    local exit_code=0
    
    # 의존성 검사
    check_dependencies || exit_code=1
    
    # 코드 포맷팅 검사 및 수정
    check_and_format_code || exit_code=1
    
    # 코드 분석
    analyze_code || exit_code=1
    
    # 테스트 실행
    run_tests || exit_code=1
    
    # 파일 크기 검사
    check_file_sizes
    
    echo "======================================"
    
    if [ $exit_code -eq 0 ]; then
        print_success "🎉 모든 pre-commit 검사가 통과되었습니다!"
        echo "======================================"
    else
        print_error "❌ Pre-commit 검사에서 문제가 발견되었습니다."
        echo "======================================"
        echo ""
        echo "문제를 해결한 후 다시 커밋해주세요:"
        echo "  git add ."
        echo "  git commit"
        echo ""
    fi
    
    exit $exit_code
}

# 스크립트 실행
main "$@"