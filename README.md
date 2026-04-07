# 🎮 게임 월드

[![GitHub Pages](https://img.shields.io/badge/배포-GitHub%20Pages-222222?logo=github)](https://hc-bang.github.io/gameWorld/)
[![License](https://img.shields.io/badge/라이선스-MIT-blue)](./LICENSE)
[![Language](https://img.shields.io/badge/언어-HTML%20%2F%20JavaScript-yellow?logo=javascript)](.)
[![Style](https://img.shields.io/badge/스타일-Vanilla%20CSS-1572B6?logo=css3)](./style.css)

> 클래식 게임 3종을 모던 네온 글래스모피즘 디자인으로 재해석한 순수 웹 기반 아케이드 게임 컬렉션입니다.

---

## 🕹️ 게임 목록

| 게임 | 아이콘 | 설명 | 조작키 |
|------|--------|------|--------|
| **테트리스** | 🧱 | 네온 효과와 고스트 블록을 적용한 클래식 테트리스 | ← → ↑ ↓ / Space |
| **스네이크** | 🐍 | 3초 카운트다운과 파티클 이펙트가 적용된 스네이크 | ← → ↑ ↓ |
| **갤러그** | 🚀 | 다이브 AI와 대형 시스템이 적용된 슈팅 게임 | ← → / Space |

---

## ✨ 주요 기능

- **3종 아케이드 게임**: 테트리스, 스네이크, 갤러그(슈터)를 하나의 포털에서 즐길 수 있습니다.
- **네온 글래스모피즘 UI**: 다크 배경에 글래스모피즘 패널과 네온 컬러 시스템을 적용한 프리미엄 디자인입니다.
- **Web Audio API 사운드**: 이동·회전·발사·클리어·게임오버 등 게임 상황별 사운드 효과를 브라우저 내장 API로 구현합니다.
- **파티클 이펙트**: 배경 플로팅 파티클 및 게임 내 이벤트(라인 클리어, 먹이 획득, 적 격파) 시 파티클 효과가 발생합니다.
- **레벨·난이도 시스템**: 점수에 따라 자동으로 레벨이 올라가며 速度 및 적 공격 빈도가 증가합니다.
- **HELP 모달**: 각 게임별 조작키 설명을 인게임 모달로 제공합니다. 모달 오픈 시 게임이 일시 정지됩니다.
- **홈 버튼**: 게임 중 좌측 상단 🏠 버튼으로 메인 메뉴로 즉시 복귀할 수 있습니다.

---

## 🗂️ 프로젝트 구조

```
gameWorld/
├── index.html       # 메인 HTML - 전체 레이아웃 및 게임 뷰 정의
├── style.css        # 전체 스타일 - 네온/글래스모피즘 디자인 시스템
├── main.js          # 게임 관리자 - SoundManager, ParticleSystem, GameManager
├── tetris.js        # 테트리스 게임 로직
├── snake.js         # 스네이크 게임 로직
├── shooter.js       # 갤러그(슈터) 게임 로직
├── .scripts/        # 로컬 서버 구동 등을 지원하는 편의 스크립트 모음
├── assets/
│   └── bg.png       # 배경 이미지
└── .agents/         # Antigravity AI 에이전트 설정
```

---

## 🛠️ 기술 스택

| 구분 | 기술 |
|------|------|
| **구조** | HTML5 (Semantic) |
| **스타일** | Vanilla CSS3 (Glassmorphism, Neon) |
| **로직** | Vanilla JavaScript (ES6+ Class) |
| **렌더링** | HTML5 Canvas API |
| **사운드** | Web Audio API |
| **폰트** | Google Fonts – Inter |
| **배포** | GitHub Pages |
| **로컬 서버** | Python HTTP Server |

---

## 🚀 로컬 실행 방법

별도의 빌드 도구 없이 정적 웹 서버만 있으면 실행할 수 있습니다.

```powershell
# 편의 스크립트를 통한 80 포트 실행 (가상환경 방어 로직 포함)
.\.scripts\run-local.ps1
```

브라우저에서 `http://localhost` 또는 `http://localhost:8080` 으로 접속합니다.

---

## 📖 상세 문서

| 문서 | 설명 |
|------|------|
| [관리자 가이드](.docs/MANAGER_GUIDE.md) | 개발 환경 구성 및 배포 절차 |
| [사용자 가이드](.docs/USER_GUIDE.md) | 각 게임 사용 방법 및 규칙 |
| [프로젝트 상태](.docs/PROJECT_STATUS.md) | 현재 개발 현황 및 To-Do |

---

## 📜 라이선스

이 프로젝트는 개인 학습 및 포트폴리오 목적으로 제작되었습니다.
