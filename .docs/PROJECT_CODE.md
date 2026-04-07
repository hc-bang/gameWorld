# 💻 시스템 코드 규격 및 자산 (PROJECT_CODE)

> 프로젝트 내 구동되는 스크립트와 객체 논리, 식별된 기술적 자산과 미래 리팩토링 필요 항목을 기록합니다.  
> **70% 식별 원칙**: 이 문서만으로 원본 소스의 70% 이상을 복원할 수 있는 수준을 목표로 합니다.

---

## 📌 전역 상수 (tetris.js)

```js
const BLOCKS = { I: [[...]], J: [[...]], L: [[...]], O: [[...]], S: [[...]], T: [[...]], Z: [[...]] };
// 각 키는 2D 배열(행렬)로 블록 형태 정의 (I는 4×4, 나머지는 3×3 또는 2×2)

const COLORS = {
    I: '#00f3ff', J: '#0055ff', L: '#ffaa00',
    O: '#ffff00', S: '#00ff00', T: '#9d00ff', Z: '#ff0044'
};
```

---

## 📌 클래스 상세 명세

### 🔊 SoundManager (`main.js`)

**생성자**: `constructor()` — `AudioContext` 생성, `masterGain` 노드를 `destination`에 연결, `gain.value = 1.0`

**핵심 메서드**:
| 메서드 | 주파수 | 파형 | 지속 | 설명 |
|--------|--------|------|------|------|
| `play(freq, type, duration, volume)` | - | - | - | 오실레이터 생성 → gain 연결 → stop 예약 |
| `move()` | 300Hz | square | 0.05s | 블록 이동 |
| `rotate()` | 400Hz | sine | 0.1s | 블록 회전 |
| `drop()` | 150Hz | square | 0.05s | 블록 착지 |
| `shoot()` | 800Hz | sawtooth | 0.05s | 갤러그 발사 |
| `clear()` | 600→800→1000Hz | sine | 0.2s×3 | 라인 클리어 (연속 화음) |
| `tick()` | 440Hz | sine | 0.05s | 카운트다운 틱 |
| `go()` | 880Hz | sine | 0.3s | 카운트다운 종료 |
| `gameOver()` | 200→150→100Hz | sawtooth | 0.5s×3 | 게임 오버 (하강 화음) |

---

### ✨ ParticleSystem (`main.js`)

**생성자**: `constructor()` — `#particle-canvas` 엘리먼트에 바인딩, `resize()` 호출, `window.resize` 이벤트 등록, `init()` 호출

**상태 필드**:
- `this.canvas`, `this.ctx`: 풀스크린 배경 캔버스 컨텍스트
- `this.particles[]`: 50개 파티클 객체 배열 `{ x, y, size(1~4), vx(-0.75~0.75), vy(-0.75~0.75), color(hsla) }`

**핵심 메서드**:
- `init()`: 파티클 50개 생성 (랜덤 위치·속도·hsl 색상), `animate()` 루프 시작
- `animate()`: `requestAnimationFrame` 기반 루프 — clearRect → 경계 랩어라운드(Wrap-around) → arc 원형 렌더링 (shadowBlur=10)

---

### 🎮 GameManager (`main.js`)

**생성자**: `constructor()` — `SoundManager`, `ParticleSystem` 인스턴스화, `this.currentGame`, `this.currentGameType`, `this.keys{}` 초기화, `initEventListeners()` 호출

**상태 필드**:
- `this.currentGame`: 현재 실행 중인 게임 인스턴스 (Tetris | Snake | Shooter | null)
- `this.currentGameType`: `'tetris' | 'snake' | 'shooter' | null`
- `this.keys{}`: keydown/up 이벤트로 관리되는 실시간 키 상태 맵 (key 문자열 + keyCode 숫자 모두 등록)
- `this.wasPaused`: 도움말 모달이 열릴 당시의 게임 일시정지 상태 저장

**핵심 메서드 흐름**:

```
switchTo(gameType)
  ├─ #main-menu: visible → hidden
  ├─ #home-btn: hidden → visible
  ├─ [gameType]-view: hidden → visible
  ├─ [gameType]-start-overlay: hidden → visible
  └─ this.currentGame = new Tetris/Snake/Shooter(canvasId, sound, onGameOver콜백)

startGame()
  ├─ this.currentGame.start()
  └─ 해당 start-overlay: visible → hidden

restartGame()
  ├─ over-overlay: visible → hidden
  ├─ this.currentGame.restart()
  └─ this.currentGame.start()

showMenu()
  ├─ this.currentGame.stop() + null
  ├─ #main-menu: visible
  ├─ #home-btn: hidden
  └─ 모든 view/overlay: hidden

showHelp()
  ├─ helpHtml = 게임 타입별 조작키 HTML 생성 (key-tag 스팬 사용)
  ├─ #help-modal: visible (setTimeout 10ms 딜레이로 CSS 트랜지션 유발)
  └─ 게임이 재생 중이면 game.paused = true (wasPaused=false 기록)

closeHelp()
  ├─ modal.classList: visible 제거
  ├─ setTimeout 300ms → hidden 추가 (CSS fade-out 대기)
  └─ wasPaused=false이면 game.paused = false 복원
```

**키보드 전역 바인딩**:
- `keydown`: `this.keys[e.key]=true`, `this.keys[e.keyCode]=true`, ESC는 `closeHelp()`, 게임 인스턴스가 있으면 `currentGame.handleInput(e)` 전달
- `keyup`: 해당 키 상태 false 해제

---

### 🧱 Tetris (`tetris.js`)

**생성자**: `constructor(canvasId, nextCanvasId, soundManager, onGameOver)`

**상태 필드**:
```js
this.gridSize = 35;      // 픽셀 단위 셀 크기
this.cols = 10;          // 보드 가로 열 수
this.rows = 20;          // 보드 세로 행 수
this.canvas.width  = 350; // cols × gridSize
this.canvas.height = 700; // rows × gridSize
this.board[][]     // 0 또는 color 문자열로 채워진 10×20 2D 배열
this.score = 0;
this.level = 1;
this.lines = 0;          // 총 클리어 라인 수 (레벨 계산 기준)
this.paused = true;
this.gameOver = false;
this.piece = { type, matrix, pos:{x,y}, color }  // 현재 블록
this.nextPiece = ...  // 다음 블록
this.dropCounter = 0;
this.dropInterval = 1000; // ms (레벨 증가 시 100ms씩 감소, 최소 100ms)
this.particles = [];
this.gameLoopId = null;
```

**핵심 메서드 흐름**:
- `spawnPiece()`: nextPiece → piece, 새 nextPiece 생성, x = 중앙 정렬, y=0. 충돌 즉시 → `handleGameOver()`
- `collide(piece)`: 행렬 순회하며 boardX/Y 계산. 경계 초과 또는 board[boardY][boardX] !== 0 이면 true
- `playerRotate()`: `rotate(matrix)` 적용 후 충돌 시 Wall-Kick (offset ±1, ±2 ... 시도, 불가 시 원복)
  - `rotate(matrix)`: `matrix[0].map((_,i) => matrix.map(col => col[i]).reverse())` — 시계방향 90° 전치
- `clearLines()`: 아래 → 위 역순 탐색, 완전 채워진 행은 `splice → unshift(빈행)`, `linesCleared × 100 × level` 점수 가산
- `getGhostPos()`: 복사본 piece를 y++ 반복, 충돌 직전 y 반환
- `drawBlock(ctx, x, y, color, isGhost)`: isGhost면 globalAlpha 0.2 strokeRect, 아니면 shadowBlur=10 fillRect + 상단 하이라이트(white 30%)
- **레벨 공식**: `level = floor(lines / 10) + 1`, `dropInterval = max(100, 1000 - (level-1) × 100)`
- **점수 공식**: `score += linesCleared × 100 × level`

---

### 🐍 Snake (`snake.js`)

**생성자**: `constructor(canvasId, soundManager, onGameOver)`

**상태 필드**:
```js
this.gridSize = 30;
this.canvas.width  = 600;
this.canvas.height = 750;
this.cols = 20; this.rows = 25;  // 600/30, 750/30
this.colors = { head: '#00f3ff', body: '#0055ff', food: '#ff0044' }
this.snake = [{x,y}, ...]  // 세그먼트 배열 (0번이 머리)
this.direction = { x:1, y:0 }
this.nextDirection = { x:1, y:0 }
this.food = { x, y }
this.score = 0;
this.level = 1;
this.paused = true;
this.gameOver = false;
this.isCountingDown = false;
this.countdown = 0;         // 3→2→1→0→GO!
this.countdownTimer = 0;    // 경과 ms 누적
this.moveInterval = 150;    // ms (레벨 증가 시 10ms씩 감소, 최소 70ms)
this.moveCounter = 0;
this.particles = [];
```

**reset()**: 초기값 전체 복원 (moveInterval=150, moveCounter=0, particles=[] 포함) — 재시작 시 잔류 버그 방지

**핵심 메서드 흐름**:
- `start()`: `isCountingDown=true`, `countdown=3`, `paused=false`, 첫 `tick()` 사운드 실행
- `update(deltaTime)`: paused/gameOver 가드 → isCountingDown 처리 (1초마다 countdown-- → tick/go 사운드) → `moveCounter += deltaTime`, `moveInterval` 초과 시 `move()`
- `move()`: direction 업데이트 → 벽 충돌 → 자기 몸 충돌 → `unshift(head)` → 먹이 충돌 (pop 생략 + 레벨업) 또는 `pop()`
- **레벨 공식**: `level = floor(score / 50) + 1`, `moveInterval = max(70, 150 - (level-1) × 10)`
- `generateFood()`: while 루프로 뱀 위치와 겹치지 않는 좌표 보장
- `draw()`: 그리드 라인(rgba white 5%) → 음식 arc(r = gridSize/2-4) → 뱀 세그먼트 `roundRect(r=5)` → 파티클 → 카운트다운 오버레이(120px bold Inter)

---

### 🚀 Shooter (`shooter.js`)

**생성자**: `constructor(canvasId, soundManager, onGameOver)`

**상태 필드**:
```js
this.canvas.width  = 600;
this.canvas.height = 750;
this.colors = { player:'#ffaa00', bullet:'#00f3ff', enemyLow:'#ff0044', enemyMid:'#ff00ff', enemyHi:'#00ff44', star:'rgba(255,255,255,0.2)' }

this.player = { x, y: height-80, size:25, speed:7, hp:3, maxHp:3 }
this.bullets = [];       // 플레이어 총알
this.enemyBullets = [];  // 적 총알
this.enemies = [];       // 적 객체 배열

this.formationX = 50;    // 대형 기준 X (좌우 오실레이션, 40~120 범위)
this.formationY = 80;    // 대형 기준 Y
this.formationDir = 1;
this.formationSpeed = 0.5;  // 레벨별 증가 (+0.1/level)
this.diveTimer = 0;
this.diveInterval = 3000;   // ms (레벨별 감소, 최소 1000ms)
this.shootTimer = 0;
this.shootInterval = 200;   // 플레이어 연사 쿨타임 ms

this.stars = [];  // 150개 별 배경 { x, y, size(0.5~2.5), speed(1~3) }
this.particles = [];
```

**적 객체 구조**:
```js
{ relX, relY,   // 대형 내 상대 좌표
  x, y,         // 실제 렌더링 좌표
  size: 18,
  color, points, // 등급별 (하위:10pt, 중위:20pt, 상위:30pt)
  state: 'formation' | 'diving' | 'returning',
  diveX, diveV, // 다이브 방향벡터·속도
  shootTimer }
```

**대형 구성**: 8열 × 4행 = 최대 32적. 행 0 = 상위(삼각형, 30pt), 행 1 = 중위(정사각형, 20pt), 행 2~3 = 하위(다이아몬드, 10pt)

**핵심 로직**:
- **대형 이동**: `formationX += dir × formationSpeed × (dt/16)`. 40~120 범위 초과 시 dir 반전
- **다이브 AI**: `diveTimer >= diveInterval`마다 'formation' 상태 적 중 랜덤 선택 → 'diving' 전환, `diveX = (player.x - e.x) / 60` (소프트 호밍), 화면 아래 → y=-50, state='returning' → 대형 Y 도달 시 'formation' 복귀
- **충돌 감지**: 모두 `Math.hypot(b.x-e.x, b.y-e.y) < e.size + b.size` 원형 충돌
- **적 사격**: state='formation'인 적의 shootTimer가 `8000/level` 초과 시 `enemyShoot(e)` 호출
- **레벨 공식**: `level = floor(score / 500) + 1`, diveInterval, formationSpeed 자동 갱신
- **HP 표시**: `#shooter-hp` 엘리먼트에 ❤️(생존)/🖤(소진) span 동적 생성

---

## 🚨 잠재적 기술 부채 및 개선안

| 항목 | 내용 | 리팩토링 제안 사항 |
| --- | --- | --- |
| **파티클 렌더링 파편화** | `Tetris`, `Shooter`, `Snake` 각각 독립적인 `createParticles(x, y, color)` 보유. 인터페이스는 동일하나 count 기본값 차이 존재 (tetris: 8, snake: 10, shooter: 12) | 단일 `FXManager`를 구성해 코어 렌더링 및 배열을 전역에서 제어. **현행 버전은 개별 독립 캔버스로 안정성 우선 — 임의 분리 보류** |
| **Shooter.handleInput() 미사용** | `handleInput(e)` 메서드가 선언되어 있으나 내부가 비어 있음. 키 처리는 `updatePlayer()` 내에서 `window.gameManager.keys`를 직접 참조 | 아키텍처 일관성을 위해 향후 `handleInput`으로 이관 권장 |

---

## 🕐 최종 업데이트

- **일시**: 2026-04-07
- **작업 내용**: 70% 식별 원칙에 따라 모든 클래스의 생성자 시그니처, 상태 필드, 메서드 흐름, 수식을 상세화. Shooter.handleInput() 미사용 이슈 추가 기록.
