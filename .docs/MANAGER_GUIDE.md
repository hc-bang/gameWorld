# 🔧 관리자 가이드 (Developer Guide)

> 서연 게임 월드 프로젝트의 개발 환경 구성, 로컬 실행, 배포 절차를 안내합니다.

---

## 1. 프로젝트 개요

| 항목 | 내용 |
|------|------|
| **프로젝트명** | 서연 게임 월드 |
| **기술 스택** | HTML5 / Vanilla CSS3 / Vanilla JavaScript |
| **배포 방식** | GitHub Pages (정적 호스팅) |
| **로컬 서버** | Python HTTP Server |
| **외부 의존성** | Google Fonts (Inter) — 인터넷 연결 시 자동 로드 |

---

## 2. 사전 요구사항

### 필수
- **웹 브라우저** (Chrome, Edge, Firefox 최신 버전 권장)
  - HTML5 Canvas, Web Audio API, CSS Backdrop-filter 지원 필요
- **Python 3.x** (로컬 서버 실행용)
  - `python --version` 으로 설치 여부 확인

### 선택
- **Git** (버전 관리 및 클론)
- **VSCode** 또는 선호하는 코드 편집기

---

## 3. 로컬 실행

### 3-1. 저장소 클론

```bash
git clone https://github.com/hc-bang/gameWorld.git
cd gameWorld
```

### 3-2. 로컬 서버 실행

별도 빌드 과정 없이 정적 파일만으로 동작합니다.

```bash
# 포트 80 (관리자 권한 필요할 수 있음)
python -m http.server 80

# 또는 일반 포트
python -m http.server 8080
```

### 3-3. 브라우저 접속

```
http://localhost        # 포트 80 사용 시
http://localhost:8080   # 포트 8080 사용 시
```

> **주의**: `file://` 프로토콜로 직접 `index.html`을 열면 Web Audio API 등 일부 기능이 제한될 수 있습니다. 반드시 HTTP 서버를 통해 접속하세요.

---

## 4. 프로젝트 구조

```
gameWorld/
│
├── index.html         # 메인 HTML - 전체 화면 레이아웃 및 게임 뷰 컨테이너
├── style.css          # 전역 CSS - 네온 변수, 글래스모피즘, 애니메이션 정의
│
├── main.js            # 게임 허브 (핵심 모듈)
│   ├── SoundManager   # Web Audio API 기반 사운드 이펙트 관리
│   ├── ParticleSystem # 배경 파티클 애니메이션 (Canvas2D)
│   └── GameManager    # 화면 전환·키 입력·게임 생명주기 통합 관리
│
├── tetris.js          # 테트리스 게임 클래스
│   ├── BLOCKS 상수    # I, J, L, O, S, T, Z 블록 행렬 정의
│   ├── COLORS 상수    # 블록별 네온 컬러 매핑
│   └── Tetris 클래스  # 게임 로직, 렌더링, 입력 처리
│
├── snake.js           # 스네이크 게임 클래스
│   └── Snake 클래스   # 이동·충돌·카운트다운·파티클 처리
│
├── shooter.js         # 갤러그 슈팅 게임 클래스
│   └── Shooter 클래스 # 적 대형·다이브 AI·총알 충돌·별 배경
│
└── assets/
    └── bg.png         # 배경 이미지 (CSS background-image로 참조)
```

---

## 5. 핵심 모듈 설명

### 5-1. GameManager (`main.js`)

전체 게임 포털의 상태와 흐름을 담당하는 최상위 컨트롤러입니다.

| 메서드 | 역할 |
|--------|------|
| `switchTo(gameType)` | 메인 메뉴 → 특정 게임 뷰로 전환, 게임 인스턴스 생성 |
| `startGame()` | 게임 시작 오버레이 숨기고 게임 루프 활성화 |
| `restartGame()` | 게임 오버 오버레이 숨기고 게임 재시작 |
| `showMenu()` | 현재 게임 정지 후 메인 메뉴 복귀 |
| `showHelp()` | 현재 게임별 조작키 모달 표시, 게임 일시정지 |
| `closeHelp()` | 모달 닫기, 이전 상태에 따라 게임 재개 |

### 5-2. SoundManager (`main.js`)

Web Audio API (`AudioContext`)로 외부 오디오 파일 없이 수학적으로 사운드를 생성합니다.

| 메서드 | 사운드 용도 |
|--------|-------------|
| `move()` | 블록/뱀 이동 |
| `rotate()` | 테트리스 블록 회전 |
| `drop()` | 하드 드롭 / 피격 |
| `shoot()` | 발사 |
| `clear()` | 라인 클리어 / 먹이 획득 / 적 격파 |
| `tick()` | 카운트다운 틱 |
| `go()` | 게임 시작 신호 |
| `gameOver()` | 게임 오버 |

### 5-3. ParticleSystem (`main.js`)

`particle-canvas` (풀스크린, `z-index: 0`)에 50개의 랜덤 색상·속도 파티클을 지속 애니메이션합니다. 벽에 닿으면 반대편으로 워프(wrap-around)됩니다.

---

## 6. 게임별 로직 요약

### 6-1. 테트리스 (`tetris.js`)

| 항목 | 내용 |
|------|------|
| 보드 크기 | 10열 × 20행, 셀 크기 35px |
| 블록 종류 | I, J, L, O, S, T, Z (7종) |
| 레벨업 조건 | 10라인 클리어마다 레벨 +1 |
| 낙하 속도 | `1000ms - (level-1) * 100ms` (최소 100ms) |
| 점수 계산 | `클리어 라인 수 × 100 × 현재 레벨` |
| 고스트 블록 | 현재 블록의 착지 예측 위치를 반투명으로 표시 |
| 파티클 | 라인 클리어 시 해당 행 각 셀에서 파티클 8개 분출 |

### 6-2. 스네이크 (`snake.js`)

| 항목 | 내용 |
|------|------|
| 맵 크기 | 600×750px, 그리드 30px |
| 시작 속도 | 150ms 간격 이동 |
| 레벨업 조건 | 50점마다 레벨 +1 |
| 이동 간격 | `150ms - (level-1) * 10ms` (최소 70ms) |
| 점수 계산 | 먹이 1개 = 10점 |
| 카운트다운 | 게임 시작 전 3·2·1·GO! 표시 |
| 충돌 판정 | 벽 충돌, 자기 몸 충돌 시 게임 오버 |

### 6-3. 갤러그/슈터 (`shooter.js`)

| 항목 | 내용 |
|------|------|
| 맵 크기 | 600×750px |
| 적 구성 | 4행 × 8열 = 32기 (하위/중위/상위 3종) |
| 점수 계산 | 하위 10점, 중위 20점, 상위 30점 |
| 플레이어 HP | 3 (하트로 표시) |
| 다이브 AI | 일정 주기마다 대형에서 무작위 적이 플레이어를 향해 돌격 |
| 발사 제한 | 200ms 쿨타임 (연사 가능) |
| 레벨업 | 매 500점마다 레벨 +1, 다이브 주기 단축·대형 속도 증가 |
| 적 전멸 | 다음 대형 즉시 생성 (무한 웨이브) |

---

## 7. CSS 디자인 시스템

### 색상 변수 (`style.css`)

```css
--neon-cyan:   #00f3ff  /* 기본 네온, 테트리스 테마 */
--neon-purple: #9d00ff  /* 제목 텍스트 네온 */
--neon-pink:   #ff00ff  /* 스네이크 테마 */
--neon-yellow: #ffff00  /* 갤러그 테마 */
--neon-green:  #00ff00  /*  */
--neon-red:    #ff0044  /* 위험·적 표시 */
--bg-dark:     #0a0a14  /* 전체 배경 */
--glass-bg:    rgba(255,255,255,0.05)  /* 글래스 패널 배경 */
--glass-border: rgba(255,255,255,0.1) /* 글래스 패널 테두리 */
```

### 주요 컴포넌트 클래스

| 클래스 | 용도 |
|--------|------|
| `.glass-panel` | 글래스모피즘 패널 |
| `.neon-text` | 네온 보라색 텍스트 (제목) |
| `.neon-button` | 네온 사이안 테두리 버튼 |
| `.game-card` | 메인 메뉴 게임 선택 카드 |
| `.overlay` | 인게임 시작/오버 오버레이 |
| `.floating` | 상하 부유 애니메이션 |
| `.hidden / .visible` | 화면 전환 표시 제어 |

---

## 8. GitHub Pages 배포

`main` 브랜치의 루트 디렉토리를 GitHub Pages 소스로 설정합니다.

1. 저장소 Settings → Pages
2. Source: `Deploy from a branch`
3. Branch: `main` / `/ (root)`
4. Save 후 몇 분 내에 `https://hc-bang.github.io/gameWorld/` 로 배포됩니다.

> `/.nojekyll` 파일이 루트에 있어 GitHub Pages의 Jekyll 처리를 비활성화합니다. 이 파일을 삭제하지 마세요.

---

## 9. 주의사항 및 알려진 제약

| 항목 | 내용 |
|------|------|
| Web Audio 정책 | 일부 브라우저는 첫 사용자 상호작용 전 AudioContext를 `suspended` 상태로 유지합니다. 카드 클릭 시 자동 재개됩니다. |
| `backdrop-filter` | Safari 최신 버전은 `-webkit-backdrop-filter`가 필요하며 이미 적용되어 있습니다. Internet Explorer는 지원하지 않습니다. |
| `roundRect` API | `snake.js`의 둥근 세그먼트 렌더링은 Chrome 99+, Edge 99+, Firefox 112+ 에서 지원됩니다. |
| 반응형 지원 | 현재 데스크톱 환경을 기준으로 제작되었습니다. 모바일 터치 조작은 지원하지 않습니다. |
