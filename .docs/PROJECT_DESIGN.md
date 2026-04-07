# 🎨 UI/UX 디자인 자산 (PROJECT_DESIGN)

> 프로젝트 공통으로 규정된 비주얼 디자인, 상호작용 지침 등 미적 자산 규격을 중앙화합니다.  
> **70% 식별 원칙**: 이 문서만으로 CSS/HTML 없이도 화면 설계의 70% 이상을 스케치할 수 있도록 구체화합니다.

---

## 📌 핵심 디자인 언어

- **방향성**: 다크 네온 글래스모피즘 (Dark Neon Glassmorphism)
- **공통 폰트**: Google Fonts **'Inter'** — `font-family: 'Inter', system-ui, sans-serif`
- **배경**: `#0a0a14` 베이스 위에 `bg.png` 배경 이미지 (`linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.8))` 오버레이 적용)
- **Z-Index 레이어 구조**:

| 레이어 | 대상 | z-index |
|--------|------|---------|
| 0 | `#particle-canvas` (배경 부유 파티클) | 0 |
| 1 | `#game-container` (게임 뷰 영역 전체) | 1 |
| 10 | `.overlay` (게임 시작/종료 오버레이) | 10 |
| 100 | `#main-menu` (게임 선택 메뉴) | 100 |
| 200 | `.home-btn` (홈 버튼) | 200 |
| 2000 | `#help-modal` (도움말 모달 오버레이) | 2000 |

---

## 🎨 CSS 변수 시스템 (`style.css :root`)

```css
:root {
    --neon-cyan:    #00f3ff;  /* 테트리스 주 색상, 버튼, 캔버스 테두리 */
    --neon-purple:  #9d00ff;  /* 타이틀 neon-text 그림자 */
    --neon-pink:    #ff00ff;  /* 스네이크 캔버스 테두리 */
    --neon-yellow:  #ffff00;  /* 갤러그 캔버스 테두리 */
    --neon-green:   #00ff00;  /* (미사용·예비) */
    --neon-red:     #ff0044;  /* 게임 오버 critical 텍스트 */
    --bg-dark:      #0a0a14;  /* body 배경 */
    --glass-bg:     rgba(255, 255, 255, 0.05);   /* 글래스 패널 배경 */
    --glass-border: rgba(255, 255, 255, 0.10);   /* 글래스 패널 테두리 */
}
```

---

## 🪟 컴포넌트 디자인 상세

### `.glass-panel` (글래스모피즘 패널)
```css
background: rgba(255, 255, 255, 0.05);
backdrop-filter: blur(10px);
-webkit-backdrop-filter: blur(10px);
border: 1px solid rgba(255, 255, 255, 0.10);
border-radius: 15px;
padding: 20px;
box-shadow: 0 8px 32px rgba(0, 0, 0, 0.37);
```
- `.glass-panel.large`: `padding: 50px; max-width: 450px`

### `.game-card` (메인 메뉴 게임 선택 카드)
```css
width: 280px; height: 380px;
backdrop-filter: blur(15px);
border-radius: 24px;
transition: all 0.4s ease;
/* Hover 효과 */
transform: translateY(-20px) scale(1.05);
box-shadow: 0 20px 40px rgba(0, 243, 255, 0.2);
```
- 테트리스 hover: `border-color: #00f3ff` + `rgba(0,243,255,0.2)` glow
- 스네이크 hover: `border-color: #ff00ff` + `rgba(255,0,255,0.2)` glow
- 갤러그 hover: `border-color: #ffff00` + `rgba(255,170,0,0.2)` glow (Orange, not Yellow)

### `.neon-button` (네온 버튼)
```css
background: transparent;
border: 2px solid #00f3ff;
color: #00f3ff;
padding: 12px 35px;
border-radius: 50px; /* 캡슐 형태 */
font-size: 1.1rem; font-weight: bold;
/* Hover */
background: #00f3ff; color: black;
box-shadow: 0 0 30px #00f3ff;
```

### `.neon-text` (네온 타이틀)
```css
font-size: 3.5rem; font-weight: 900;
text-shadow: 0 0 20px #9d00ff;
```
- `.neon-text.critical` (게임 오버): `color: #ff0044; text-shadow: 0 0 20px #ff0044, 0 0 40px #ff0044`

### `canvas.game-canvas` (게임 캔버스 공통)
```css
background: rgba(0, 0, 0, 0.7);
border: 2px solid #00f3ff;
box-shadow: 0 0 30px rgba(0, 243, 255, 0.2);
border-radius: 12px;
max-height: 85vh;
```
- `#snake-view canvas`: 테두리 `#ff00ff`, 쉐도우 `rgba(255,0,255, 0.2)`, `aspect-ratio: 4/5`
- `#shooter-view canvas`: 테두리 `#ffff00`, 쉐도우 `rgba(255,170,0, 0.2)`, `aspect-ratio: 5/7`

### `.home-btn` (홈 복귀 버튼)
```css
position: fixed; top: 30px; left: 30px;
width: 60px; height: 60px; border-radius: 50%;
background: rgba(255,255,255,0.05);
backdrop-filter: blur(10px);
font-size: 1.5rem;
/* Hover: 배경 white, 글자 black, rotate(-90deg) */
```

### `.modal-overlay` (도움말 모달 배경)
```css
position: fixed; top:0; left:0; width:100%; height:100%;
background: rgba(0, 0, 0, 0.8);
backdrop-filter: blur(10px);
z-index: 2000;
opacity: 0; pointer-events: none;   /* .hidden 상태 */
transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
/* .visible 시: opacity: 1; pointer-events: auto */
```

---

## 🔲 레이아웃 구조 (DOM 트리 계층)

```
<body>
  <canvas #particle-canvas />   ← z-index 0, 배경 파티클
  <button #home-btn />          ← z-index 200, fixed
  <div #game-container>         ← z-index 1
    <div #main-menu>            ← z-index 100, absolute 100% × 100%
      <h1 .neon-text.floating>
      <div .menu-cards>
        <div .game-card.tetris #select-tetris>
        <div .game-card.snake  #select-snake>
        <div .game-card.shooter #select-shooter>
    <div #tetris-view>
      <div .game-arena>
        <div #tetris-next-panel .glass-panel.side-panel> ← 오른쪽 캔버스의 왼쪽에 절대 위치
        <canvas #game-canvas />
      <div .ui-panel>             ← absolute, right:40px
        <div .glass-panel>{점수}
        <div .glass-panel>{레벨}
        <button .neon-button.help-btn>
      <div #tetris-start-overlay .overlay>
      <div #tetris-over-overlay  .overlay>
    <div #snake-view>   (동일 구조, ui-panel에 점수만)
    <div #shooter-view> (동일 구조, ui-panel에 점수+생명)
  <div #help-modal .modal-overlay>
    <div .modal-container.glass-panel.large>
      <button .modal-close-x>×</button>
      <div #help-content>   ← JS로 동적 주입
      <button #help-close-btn .neon-button>
```

---

## 🌟 상호작용(Interaction) 방향

1. **Hover Effect**: 게임 카드는 `translateY(-20px) scale(1.05)` + 네온 tint 글로우 (색상은 게임별 상이)
2. **화면 전환**: `.hidden` = `opacity:0; pointer-events:none; transform:scale(1.1); display:none !important`, `.visible` = `opacity:1; transform:scale(1); display:flex !important` — 클래스 토글로 전환
3. **모달 진입**: HELP 진입 → black tint(rgba 0.8) + blur(10px) 확장, 게임 `paused=true` 강제. 모달 종료 → fade-out 300ms 후 hidden, 게임 재개
4. **파티클 피드백**: 라인 클리어(tetris), 먹이 획득(snake), 적 격파(shooter) 시 해당 캔버스 내 색상 파티클 방사
5. **홈 버튼**: hover 시 반시계방향 90° 회전 (`rotate(-90deg)`) + 흰 배경 전환
6. **타이틀 애니메이션**: `.floating` 클래스 — `float` keyframe (translateY 0→-10px→0, 3s ease-in-out infinite)

---

## 🗂️ 게임 캔버스 내부 렌더링 색상

| 대상 | 색상 | 비고 |
|------|------|------|
| 테트리스 블록 I | `#00f3ff` | 하이라이트: white 30% |
| 테트리스 블록 T | `#9d00ff` | shadowBlur=10 |
| 테트리스 고스트 | 해당 블록 색 | globalAlpha=0.2, strokeRect |
| 스네이크 머리 | `#00f3ff` | shadowBlur=15 |
| 스네이크 몸 | `#0055ff` | shadowBlur=5 |
| 스네이크 먹이 | `#ff0044` | arc 원형, shadowBlur=15 |
| 갤러그 플레이어 | `#ffaa00` | 삼각형, shadowBlur=20 |
| 갤러그 총알 | `#00f3ff` | arc |
| 갤러그 적(하위) | `#ff0044` | 다이아몬드, globalAlpha 0.3 채우기 |
| 갤러그 적(중위) | `#ff00ff` | 정사각형 |
| 갤러그 적(상위) | `#00ff44` | 삼각형 (30pt) |
| 갤러그 별 배경 | `rgba(255,255,255,0.2)` | 150개 arc |

---

## 🕐 최종 업데이트

- **일시**: 2026-04-07
- **작업 내용**: 70% 식별 원칙에 따라 CSS 변수 전체 목록, Z-Index 레이어 다이어그램, DOM 트리 계층, 각 컴포넌트 정확한 수치(box-shadow, border-radius, rgba) 및 게임 캔버스 내부 렌더링 색상 테이블을 상세화.
