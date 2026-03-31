# Linux / Docker / Git 기초 학습

## 1. 프로젝트 개요

리눅스 터미널 기본 명령어, 파일 권한, Docker 컨테이너 운영,
Dockerfile 기반 커스텀 이미지 생성, Git/GitHub 연동까지
DevOps 기초 역량을 실습하고 기록한 저장소입니다.

---

## 2. 실행 환경

| 항목 | 버전 / 정보 |
|------|-------------|
| OS | `macOS 26.3.1` |
| Shell | `zsh` |
| Terminal | `기본 터미널` |
| Docker | `Docker version 29.3.0, build 5927d80` |
| Docker Compose | `Docker Compose version v5.1.0` |
| Git | `git version 2.50.1 (Apple Git-155)` |

> 💡 아래 명령어로 각각 확인할 수 있습니다.
> ```bash
> docker --version      # Docker
> docker compose version # Docker Compose
> git --version         # Git
> ```

---

## 3. 수행 항목 체크리스트

### 3-1. 터미널 기본 명령어

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 현재 위치 확인 | `pwd` |
| [ ] | 목록 확인 | `ls`, `ls -al` |
| [ ] | 디렉터리 이동 | `cd 절대경로`, `cd ./상대경로` |
| [ ] | 디렉터리 생성 | `mkdir`, `mkdir -p a/b/c` |
| [ ] | 파일/디렉터리 복사 | `cp`, `cp -r` |
| [ ] | 이동 / 이름 변경 | `mv` |
| [ ] | 삭제 | `rm`, `rm -rf` |
| [ ] | 파일 내용 확인 | `cat`, `head`, `tail`, `less` |
| [ ] | 빈 파일 생성 | `touch` |

### 📌 터미널 명령어 옵션 상세 설명

---

#### 1. 경로 표기법: `.` / `..` / `/`

```
/           ← 루트(최상위) 디렉터리
~           ← 홈 디렉터리 (/home/사용자명)
.           ← 현재 디렉터리
..          ← 상위(부모) 디렉터리
```

**실습 예시**

```bash
pwd
# /home/user/project

cd ./src        # 현재 위치의 src 폴더로 이동
pwd
# /home/user/project/src

cd ..           # 한 단계 위로 이동
pwd
# /home/user/project

cd ../../       # 두 단계 위로 이동
pwd
# /home

cd /etc         # 절대경로: 어디서든 /etc로 바로 이동
pwd
# /etc
```

| 표기 | 의미 | 예시 | 결과 |
|------|------|------|------|
| `.` | 현재 디렉터리 | `cd ./src` | 현재 위치의 src로 이동 |
| `..` | 상위 디렉터리 | `cd ..` | 한 단계 위로 이동 |
| `../..` | 2단계 상위 | `cd ../..` | 두 단계 위로 이동 |
| `/` | 루트(절대경로 시작) | `cd /home/user` | 루트 기준으로 이동 |

> 💡 **핵심 차이:**
> - `./` → **현재 위치 기준** 아래로 탐색
> - `../` → **현재 위치 기준** 위로 탐색
> - `/` → **항상 루트 기준** (현재 위치 무관)

---

#### 2. `ls` 옵션: `-a`, `-l`

```bash
ls          # 기본 목록 (숨김 파일 제외)
ls -a       # 숨김 파일 포함 전체 목록
ls -l       # 상세 정보 (권한, 소유자, 크기, 날짜)
ls -al      # 숨김 파일 + 상세 정보 (가장 많이 사용!)
```

| 옵션 | 의미 | 설명 |
|------|------|------|
| `-a` | **all** | `.`으로 시작하는 숨김 파일까지 모두 표시 |
| `-l` | **long** | 권한, 소유자, 크기, 수정일 등 상세 정보 표시 |

**`ls -l` 출력 읽는 법**

```
-rw-r--r--  1  user  group  1024  Jun 15 10:30  file.txt
│           │  │     │      │     │              │
├ 권한      │  소유자 그룹   크기   수정일          파일명
└ 파일타입   └ 하드링크 수
  - : 일반파일
  d : 디렉터리
  l : 심볼릭링크
```

---

#### 3. `mkdir` 옵션: `-p`

```bash
mkdir src                    # src 디렉터리 1개 생성
mkdir src/components/ui      # ❌ 에러! src/components가 없으면 실패

mkdir -p src/components/ui   # ✅ 중간 경로까지 한번에 전부 생성
```

| 옵션 | 의미 | 설명 |
|------|------|------|
| `-p` | **parents** | 중간 부모 디렉터리가 없으면 자동으로 함께 생성 |

```
mkdir -p 실행 결과:

src/                  ← 자동 생성
└── components/       ← 자동 생성
    └── ui/           ← 최종 목표
```

> 💡 `-p` 없이 실행하면 중간 디렉터리가 없을 때
> `No such file or directory` 에러가 발생합니다.

---

#### 4. `cp` 옵션: `-r`

```bash
cp file1.txt file2.txt          # ✅ 파일 복사 (옵션 불필요)
cp my-folder/ backup-folder/    # ❌ 에러! 디렉터리는 -r 필요

cp -r my-folder/ backup-folder/ # ✅ 디렉터리 + 내부 파일 전체 복사
```

| 옵션 | 의미 | 설명 |
|------|------|------|
| `-r` | **recursive (재귀)** | 디렉터리 내부의 모든 하위 파일/폴더를 포함하여 복사 |

```
cp -r 실행 흐름:

my-folder/              →    backup-folder/
├── index.html          →    ├── index.html
├── css/                →    ├── css/
│   └── style.css       →    │   └── style.css
└── js/                 →    └── js/
    └── app.js          →        └── app.js
```

> 💡 **파일 1개 복사** → `cp` 만으로 충분
> **디렉터리 통째로 복사** → 반드시 `cp -r`

---

#### 5. `rm` 옵션: `-r`, `-f`

```bash
rm file.txt             # 파일 1개 삭제 (확인 메시지 있음)
rm -r my-folder/        # 디렉터리 + 내부 전체 삭제 (확인 메시지 있음)
rm -f file.txt          # 강제 삭제 (확인 메시지 없음)
rm -rf my-folder/       # 디렉터리 전체를 확인 없이 강제 삭제
```

| 옵션 | 의미 | 설명 |
|------|------|------|
| `-r` | **recursive (재귀)** | 디렉터리 내부 모든 파일/폴더를 포함하여 삭제 |
| `-f` | **force (강제)** | 확인 질문 없이 즉시 삭제, 없는 파일도 에러 무시 |
| `-rf` | **재귀 + 강제** | 디렉터리 전체를 묻지 않고 삭제 |

> ⚠️ **주의:** `rm -rf /` 같은 명령은 시스템 전체를 삭제할 수 있습니다!
> 항상 삭제 대상 경로를 정확히 확인하고 실행하세요.
>
> ```bash
> # 위험한 예시 (절대 실행 금지!)
> rm -rf /                    # ❌ 시스템 전체 삭제
> rm -rf ~                    # ❌ 홈 디렉터리 전체 삭제
>
> # 안전한 사용법
> rm -rf ./test-folder/       # ✅ 현재 위치의 특정 폴더만 삭제
> ```

---

#### 6. 파일 내용 확인: `cat` / `head` / `tail` / `less` 비교

```bash
cat  file.txt           # 파일 전체 내용을 한번에 출력
head file.txt           # 파일 앞부분 10줄만 출력
tail file.txt           # 파일 뒷부분 10줄만 출력
less file.txt           # 스크롤 가능한 뷰어로 열기 (q로 종료)
```

| 명령어 | 출력 범위 | 특징 | 적합한 상황 |
|--------|----------|------|------------|
| `cat` | **전체** | 한번에 전부 출력 | 짧은 파일, 내용 빠르게 확인 |
| `head` | **앞 10줄** | 파일 시작 부분만 | 파일 구조/헤더 확인 |
| `tail` | **뒤 10줄** | 파일 끝 부분만 | 로그 파일 최신 내용 확인 |
| `less` | **전체 (스크롤)** | 위아래 이동 가능 | 긴 파일 천천히 읽기 |

**유용한 옵션**

```bash
# head / tail: 줄 수 지정
head -n 20 file.txt     # 앞에서 20줄 출력
tail -n 5  file.txt     # 뒤에서 5줄 출력

# tail: 실시간 모니터링 (로그 감시에 필수!)
tail -f /var/log/syslog  # 파일에 새 내용이 추가되면 실시간 출력
                          # Ctrl+C로 종료

# less: 내부 단축키
#   ↑↓    : 한 줄씩 이동
#   Space : 한 페이지 아래로
#   b     : 한 페이지 위로
#   /검색어 : 문자열 검색
#   q     : 종료

# cat: 여러 파일 합치기
cat file1.txt file2.txt > merged.txt   # 두 파일을 합쳐서 새 파일 생성
```

> 💡 **실무 꿀팁:**
> - 설정 파일 확인 → `cat` (보통 짧으니까)
> - 로그 파일 실시간 감시 → `tail -f`
> - 긴 파일 탐색 → `less`
> - CSV/데이터 파일 앞부분만 확인 → `head -n 5`

### 3-2. 권한 (Permission)

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 현재 권한 확인 | `ls -l` |
| [ ] | 파일 권한 변경 (숫자) | `chmod 755 파일명` |
| [ ] | 파일 권한 변경 (문자) | `chmod u+x 파일명` |
| [ ] | 디렉터리 권한 변경 | `chmod -R 755 디렉터리명` |
| [ ] | 소유자 변경 | `chown user:group 파일명` |

> **참고: 퍼미션 숫자 표기**
> ```
> r(읽기) = 4    w(쓰기) = 2    x(실행) = 1
>
> 예) chmod 755
>   소유자: 7 (4+2+1) = rwx
>   그룹:   5 (4+0+1) = r-x
>   기타:   5 (4+0+1) = r-x
> ```

### 3-3. Docker 기본

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 버전 확인 | `docker --version` |
| [ ] | 데몬 동작 여부 확인 | `systemctl status docker` 또는 `docker info` |

### 3-4. Docker 기본 운영 명령

#### 이미지 관련

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 이미지 검색 | `docker search 이미지명` |
| [ ] | 이미지 다운로드 | `docker pull 이미지명` |
| [ ] | 이미지 목록 확인 | `docker images` |
| [ ] | 이미지 삭제 | `docker rmi 이미지명` |

#### 컨테이너 관련

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 컨테이너 실행 | `docker run 이미지명` |
| [ ] | 실행 중 컨테이너 확인 | `docker ps` |
| [ ] | 전체 컨테이너 확인 | `docker ps -a` |
| [ ] | 컨테이너 중지 | `docker stop 컨테이너ID` |
| [ ] | 컨테이너 삭제 | `docker rm 컨테이너ID` |
| [ ] | 컨테이너 로그 확인 | `docker logs 컨테이너ID` |

#### 운영 관련

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 컨테이너 내부 접속 | `docker exec -it 컨테이너ID /bin/bash` |
| [ ] | 리소스 사용량 확인 | `docker stats` |
| [ ] | 전체 정리 (미사용 리소스) | `docker system prune` |

### 3-5. 컨테이너 실행 실습

#### ✅ hello-world 실행

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | hello-world 실행 성공 | `docker run hello-world` |

#### ✅ Ubuntu 컨테이너 실습

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | Ubuntu 컨테이너 실행 + 내부 진입 | `docker run -it ubuntu /bin/bash` |
| [ ] | 내부에서 명령어 실행 기록 | `ls`, `pwd`, `cat /etc/os-release` 등 |
| [ ] | 컨테이너 종료/유지 차이 정리 | `exit` vs `Ctrl+P,Q` → `docker ps` 비교 |

#### ✅ 포트 매핑 및 접속

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 포트 매핑하여 컨테이너 실행 | `docker run -d -p 8080:80 nginx` |
| [ ] | 브라우저 또는 curl로 접속 확인 | `curl http://localhost:8080` |

#### ✅ Docker 볼륨 영속성 검증

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 볼륨 생성 | `docker volume create mydata` |
| [ ] | 볼륨 연결하여 컨테이너 실행 | `docker run -v mydata:/data ubuntu` |
| [ ] | 컨테이너 내부에서 데이터 생성 | `echo "test" > /data/test.txt` |
| [ ] | 컨테이너 삭제 | `docker rm 컨테이너ID` |
| [ ] | 새 컨테이너에 같은 볼륨 연결 | `docker run -v mydata:/data ubuntu cat /data/test.txt` |
| [ ] | 데이터 유지 확인 (영속성 증명) | 출력 결과로 `test` 문자열 확인 |

### 3-6. Dockerfile 기반 커스텀 이미지 생성

| 완료 | 항목 | 설명 |
|:----:|------|------|
| [ ] | 베이스 이미지 선택 | `nginx` 또는 `httpd` 등 웹서버 이미지 |
| [ ] | 정적 콘텐츠 추가 | `COPY index.html /usr/share/nginx/html/` |
| [ ] | 설정 파일 변경 | `COPY nginx.conf /etc/nginx/nginx.conf` |
| [ ] | 커스텀 이미지 빌드 | `docker build -t my-web .` |
| [ ] | 커스텀 이미지 실행 | `docker run -d -p 8080:80 my-web` |
| [ ] | 커스텀 포인트별 목적 정리 | 각 `COPY`, `RUN` 등의 이유 문서화 |

> **Dockerfile 예시**
> ```dockerfile
> FROM nginx:latest
> COPY index.html /usr/share/nginx/html/
> COPY nginx.conf /etc/nginx/nginx.conf
> EXPOSE 80
> CMD ["nginx", "-g", "daemon off;"]
> ```

### 3-7. Docker Compose 설정

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | `docker-compose.yml` 작성 (멀티 컨테이너) | 웹서버 + DB 등 2개 이상 서비스 구성 |
| [ ] | 환경 변수 적용 | `environment:` 또는 `.env` 파일 활용 |
| [ ] | Compose 실행 | `docker compose up -d` |
| [ ] | Compose 중지 및 정리 | `docker compose down` |

> **docker-compose.yml 예시**
> ```yaml
> version: "3.8"
> services:
>   web:
>     image: nginx:latest
>     ports:
>       - "8080:80"
>   db:
>     image: mysql:8.0
>     environment:
>       MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
>       MYSQL_DATABASE: mydb
>     volumes:
>       - db-data:/var/lib/mysql
> volumes:
>   db-data:
> ```

### 3-8. Git / GitHub

| 완료 | 항목 | 핵심 명령어 |
|:----:|------|------------|
| [ ] | 사용자 이름 설정 | `git config --global user.name "이름"` |
| [ ] | 이메일 설정 | `git config --global user.email "이메일"` |
| [ ] | 설정 확인 | `git config --list` |
| [ ] | 로컬 저장소 초기화 | `git init` |
| [ ] | 스테이징 + 커밋 | `git add .` → `git commit -m "메시지"` |
| [ ] | GitHub 원격 저장소 연결 | `git remote add origin URL` |
| [ ] | 푸시 | `git push -u origin main` |
| [ ] | 커밋 로그 확인 | `git log --oneline` |

---

## 4. 검증 방법

> 각 항목마다 **"어떤 명령 → 무엇을 확인 → 실습 결과"** 3단계로 검증합니다.

### 4-1. 터미널 기본 명령어

| 검증 대상 | 실행 명령어 | 예상 결과 | 실습 결과 |
|-----------|-----------|-----------|-----------|
| 현재 위치 확인 | `pwd` | 현재 디렉터리 절대경로 출력 | `screenshots/terminal-pwd.png` |
| 목록 확인 | `ls -al` | 숨김 파일 포함 전체 목록 출력 | `screenshots/terminal-ls.png` |
| 디렉터리 생성 | `mkdir -p test/a/b` → `tree test` | 중첩 디렉터리 생성 확인 | `screenshots/terminal-mkdir.png` |
| 파일 복사 | `cp a.txt b.txt` → `ls` | 복사된 파일 존재 확인 | `screenshots/terminal-cp.png` |
| 파일 이동/이름변경 | `mv a.txt new.txt` → `ls` | 이름 변경 확인 | `screenshots/terminal-mv.png` |
| 삭제 | `rm -rf test/` → `ls` | 디렉터리 삭제 확인 | `screenshots/terminal-rm.png` |
| 파일 내용 확인 | `cat 파일명` | 파일 내용 출력 | `screenshots/terminal-cat.png` |
| 빈 파일 생성 | `touch empty.txt` → `ls -l` | 0바이트 파일 생성 확인 | `screenshots/terminal-touch.png` |

### 4-2. 권한

| 검증 대상 | 실행 명령어 | 예상 결과 | 실습 결과 |
|-----------|-----------|-----------|-----------|
| 권한 확인 | `ls -l 파일명` | `-rwxr-xr-x` 형태 출력 | `screenshots/perm-before.png` |
| 숫자로 권한 변경 | `chmod 644 파일명` → `ls -l` | `-rw-r--r--` 확인 | `screenshots/perm-chmod-num.png` |
| 문자로 권한 변경 | `chmod u+x 파일명` → `ls -l` | 실행 권한 추가 확인 | `screenshots/perm-chmod-str.png` |
| 디렉터리 재귀 변경 | `chmod -R 755 dir/` → `ls -lR dir/` | 하위 전체 변경 확인 | `screenshots/perm-recursive.png` |

### 4-3. Docker 기본

| 검증 대상 | 실행 명령어 | 예상 결과 | 실습 결과 |
|-----------|-----------|-----------|-----------|
| 버전 확인 | `docker --version` | 버전 번호 출력 | `screenshots/docker-version.png` |
| 데몬 상태 | `docker info` | Server 정보 정상 출력 | `screenshots/docker-info.png` |
| hello-world | `docker run