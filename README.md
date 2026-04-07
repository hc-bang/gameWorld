# Neon Game World

## 🚀 프로젝트 개요
순수 바닐라 웹 기술(HTML5 Canvas, Vanilla JS, CSS3)만으로 구현된 다기능 통합 아케이드 게임 플랫폼입니다.
가벼운 실행과 직관적인 조작감을 목적으로 하며, 외부 이미지나 사운드 에셋(MP3, PNG 등)에 절대적으로 의존하지 않고 코드만으로 주파수 효과음과 파티클 렌더링을 동적으로 생성해내는 경량화 아키텍처를 채택했습니다.

## 🕹 핵심 기능 스펙
| 카테고리 | 세부 내용 | 구현 형태 |
| --- | --- | --- |
| **미니 게임 3종** | 테트리스(Tetris), 스네이크(Snake), 슈터(Shooter) | 단일 캔버스 컨텍스트 및 모듈별 `class` 인스턴스 분리 |
| **엔진 사운드** | Web Audio API 완전 자체 합성 | 주파수(`sine`, `sawtooth` 등) 및 `OscillatorNode` 기반 실시간 합성 |
| **시각 이펙트** | 무한 파티클 시스템 & 글래스모피즘 | 프레임 제어(`requestAnimationFrame`) 기반 구체 렌더링 및 CSS 조합 |

## 🛠 기술 스택
| 시스템 영역 | 활용 스택 및 언어 | 아키텍처 구현 근거 (사유) |
| --- | --- | --- |
| **Language** | HTML5, CSS3, JavaScript (ES6+) | 외부 프레임워크나 서드파티 라이브러리 없이 가장 빠르고 직관적인 물리 엔진 구축 |
| **Environment** | Python 3.x (Local Runtime) | 정적 에셋 서빙 시 필연적인 브라우저 `CORS` 차단 이슈를 극복하기 위한 로컬 모듈 활용 |

## 📂 프로젝트 구조 (트리 맵)
```text
프로젝트-루트/
├── .scripts/              (자동화 실행 스크립트)
│   └── run-local.ps1      (Python HTTP Server 가동 처리기)
├── .docs/                 (시스템 지식 베이스 및 규정 집합)
│   ├── MANAGER_GUIDE.md   (설치 및 관리 운영 가이드)
│   ├── USER_GUIDE.md      (엔드 유저 사용 매뉴얼)
│   ├── PROJECT_CODE.md    (시스템 코어 로직 SSOT)
│   ├── PROJECT_DESIGN.md  (디자인 물리 자산 SSOT)
│   └── PROJECT_STATUS.md  (현재 상태 모니터링 보드)
├── index.html             (메인 DOM 진입점)
├── style.css              (글래스모피즘/네온 글로벌 스타일링)
├── main.js                (싱글톤 GameManager 및 글로벌 사운드 컨트롤러)
├── tetris.js              (테트리스 코어 모델)
├── snake.js               (스네이크 코어 모델)
└── shooter.js             (슈터 디펜스 모델)
```
