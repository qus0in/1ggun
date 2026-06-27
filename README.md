# 1gun

AI 코딩 에이전트에 소리 훅을 추가합니다. 각 에이전트마다 다른 목소리가 이벤트에 반응합니다.

> macOS 전용 (`afplay` 사용)

## 설치

프로젝트 루트에서 실행:

```bash
curl -fsSL https://raw.githubusercontent.com/qus0in/1gun/main/install.sh | bash
```

설치 후 생성/수정되는 파일:

```
.agents/
  sound_hook.sh        # 훅 실행 스크립트
  sound/               # MP3 파일들
  hooks.json           # AGY 훅 설정
.claude/
  settings.json        # Claude Code 훅 설정
.codex/
  hooks.json           # Codex 훅 설정
```

## 에이전트별 목소리

| 에이전트    | 인자    | 목소리    |
| ----------- | ------- | --------- |
| Claude Code | `cc`    | 조선 일꾼 |
| Codex       | `codex` | 일본 일꾼 |
| AGY         | `agy`   | 명 일꾼   |

## 이벤트 매핑

| 이벤트            | cc (조선 일꾼)    | codex (일본 일꾼) | agy (명 일꾼)     |
| ----------------- | ----------------- | ----------------- | ----------------- |
| SessionStart      | 찾으셨나요        | 갑니다요          | -                 |
| UserPromptSubmit  | 그렇게 합죠       | 녜녜 그렇게 합죠  | -                 |
| PermissionRequest | 열심히 하겠습니다 | 걱정마십쇼        | -                 |
| Notification      | 말씀하세요        | -                 | -                 |
| Stop              | 말씀하세요        | 어떤 일을 할까요  | 분부만 내리세요   |
| PreInvocation     | -                 | -                 | 네네 알겠습니다요 |

## 커스터마이징

이벤트별 재생 파일을 바꾸려면 `.agents/sound_hook.sh`를 수정합니다.

## 업데이트

동일한 명령어를 재실행하면 파일을 덮어쓰고 설정을 갱신합니다.

```bash
curl -fsSL https://raw.githubusercontent.com/qus0in/1gun/main/install.sh | bash
```
