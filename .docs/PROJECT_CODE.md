# 프로젝트 코드 명세 (PROJECT_CODE.md)

## 단일 진실 공급원 (SSOT)
시스템 내의 유틸리티, 핵심 모듈 및 공통 함수의 구조를 강제하여 중복 개발을 원천 차단합니다.

### 1. 전역 시스템 관리 객체
#### `GameManager` (in `main.js`)
* **역할:** 게임 모드 간 화면 씬(Scene) 전환, 전역 키보드 이벤트, 헬프 모달 렌더링, 오디오/파티클 시스템을 통합 제어하는 싱글톤 컨텍스트.
* **주요 멤버 변수(State):** 
  - `this.currentGame`: 현재 활성화된 게임 인스턴스 (다형성 활용)
  - `this.currentGameType`: 상태 문자열 ('tetris', 'snake', 'shooter')
  - `this.keys`: 입력된 키 상태 객체 (예: `this.keys['ArrowRight'] = true`)
* **주요 메서드 서명(Signature):**
  - `switchTo(gameType: string)`: 돔(DOM) 클래스 제어를 통해 메인 메뉴(`hidden`)와 타겟 캔버스뷰(`visible`)를 스위칭하며, 캔버스별 새 인스턴스를 주입함.
  - `showHelp() / closeHelp()`: `currentGameType` 변수에 따라 헬프 모달 내 DOM(`help-content`)에 각기 다른 조작법 HTML 문자열 조각을 주입함. 호출 시 활성화된 게임은 일시 정지 처리됨.

### 2. 공통 유틸리티 모듈
#### `SoundManager` (in `main.js`)
* **역할:** 외부 MP3 에셋 없이 Web Audio API를 활용해 주파수로 효과음을 합성하는 경량 엔진.
* **핵심 함수:**
  - `play(freq: number, type: string = 'sine', duration: number = 0.1, volume: number = 0.3)`
  - **동작 방식:** `OscillatorNode`와 `GainNode`를 마스터로 연결하여, Duration 경과 시 볼륨을 `0.0001`로 감쇄(Exponential Ramp)시킴.
* **공통 프리셋(Presets):**
  - `shoot()`: 800Hz / sawtooth / 0.05s
  - `gameOver()`: 200 -> 150 -> 100Hz 계단식 하강음 배열 (setTimeout 연계)

#### `ParticleSystem` (in `main.js`)
* **역할:** #particle-canvas 레이어 상에서 50개의 객체를 `hsla()` 색상과 함께 애니메이션하는 백그라운드 엔진.
* **동작 방식:** 초기화 시 랜덤 `vx, vy` (속도 벡터)를 부여받은 파티클이 화면 밖을 벗어나면 반대편 좌표로 워프하는 무한 루프.

#### `ParticleHelper` (in `main.js`)
* **역할:** 내부 미니게임(`Tetris`, `Snake`, `Shooter`)들에서 개별 구현되던 파티클 이펙트 로직을 통합한 공통 유틸리티 클래스.
* **주요 정적(Static) 메서드 서명:**
  - `create(particles: array, x: number, y: number, color: string, count: number, speed: number, drainRate: number)`: 파티클 생성 (소멸률 `drainRate` 매개변수로 유연성 확보)
  - `update(particles: array, deltaTime: number)`: 수명(`life`) 감소 및 이동 벡터 동기화 연산
  - `draw(ctx: object, particles: array)`: 캔버스 컨텍스트(`ctx`)를 주입받아 원형(Arc) 렌더링

### 3. 미니 게임 아키텍처 제약사항
* 향후 추가/수정될 모든 게임 모드(`Tetris`, `Snake`, `Shooter`)는 공통적으로 아래의 시그니처 뼈대를 상속(혹은 매칭)하여 구성해야 함.
* **생성자:** `constructor(canvasId: string, soundManager: obj, onGameOver: function(score))`
* **필수 구현 메서드:** `start()`, `stop()`, `restart()`, `handleInput(event)`
