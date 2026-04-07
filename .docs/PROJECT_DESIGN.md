# 프로젝트 디자인 자산 (PROJECT_DESIGN.md)

## 디자인 토큰 (Design Tokens)
프로젝트 전반의 통일성을 지배하는 기본 컬러 설정 및 변수입니다. (`style.css` 척추 구조)

| 토큰명 (Token) | 색상 수치 (Hex/RGBA) | 반영 영역 및 용도 |
| --- | --- | --- |
| `--neon-cyan` | `#00f3ff` | 메인 테마, 테트리스 캔버스 아웃라인, 네온 버튼 디폴트 |
| `--neon-purple` | `#9d00ff` | 텍스트 네온 이펙트 섀도우 |
| `--neon-pink` | `#ff00ff` | 스네이크 모드 강조 컬러 |
| `--neon-yellow` | `#ffff00` | 슈터 모드 강조 컬러 |
| `--neon-red` | `#ff0044` | 게임 오버 위험(`critical`) 상태, 피격 이펙트 |
| `--bg-dark` | `#0a0a14` | 시스템 최하단 베이스 백그라운드 |
| `--glass-bg` | `rgba(255,255,255, 0.05)` | 모든 모달 및 패널의 글래스모피즘 반투명 베이스 |
| `--glass-border`| `rgba(255,255,255, 0.1)` | 글래스모피즘 컴포넌트의 테두리 윤곽선 |

## Z-Index 아키텍처
DOM 요소의 깊이와 터치/마우스 이벤트 충돌 방지를 보장하는 레이어 계층입니다.

| 레이어/컴포넌트 | Z-Index | 물리적 모션 및 제어 |
| --- | --- | --- |
| 파티클 배경 (`#particle-canvas`) | `0` | 가장 밑바닥 고정, `pointer-events: none`을 주어 클릭을 통과시킴 |
| 게임 캔버스 (`#game-container`) | `1` | `perspective: 1000px`로 컨테이너 원근감 보장 |
| 내부 오버레이 (`.overlay`) | `10` | 진행 중인 캔버스 위를 덮는 임시 창 (`rgba(0,0,0, 0.9)`) |
| 메인 메뉴 (`#main-menu`) | `100` | 최상위 뷰를 완전히 분리하는 Absolute 카드 컨테이너 |
| 나가기 홈 버튼 (`.home-btn`) | `200` | 화면 좌상단에 `fixed` (마우스 호버 시 90도 회전 애니메이션) |
| 헬프 모달 (`.modal-overlay`) | `2000` | 다른 모든 조작을 완전히 차단하는 최상위 블러 렌더링 |

## 핵심 UI 컴포넌트 뼈대

### 1. 글래스 패널 베이스 (`.glass-panel`)
* **형태 수치:** `background: var(--glass-bg)`, `backdrop-filter: blur(10px)` (배경 흐림)
* **외형 수치:** `border-radius: 15px`, `box-shadow: 0 8px 32px rgba(0, 0, 0, 0.37)`

### 2. 메뉴 선택 카드 (`.game-card`)
* **초기 수치:** `width: 280px`, `height: 380px`, `padding: 30px`
* **인터랙션(Hover):** 카드 위로 마우스가 올라가면 `transform: translateY(-20px) scale(1.05);`로 튀어오름. 대상 분류에 따라 고유 네온 컬러(`--neon-***`) 계열의 `box-shadow`가 발광함.

### 3. 네온 버튼 (`.neon-button`)
* **스타일:** 내부 영역은 `transparent`로 글래스 뷰를 살림. 테두리는 `2px solid var(--neon-cyan)`. 
* **인터랙션:** 터치/마우스 진입 시 배경을 Cyan으로 덮어버리고 블랙 텍스트로 반전시킴.
