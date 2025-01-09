# Frontend

### 코드 컨벤션

- 식별자는 **카멜케이스**로 작성

ex) var camelCase

중간 글자들은 대문자로 시작하지만 첫 글자가 소문자인 경우

- **문자열을 처리할 때는 쌍따옴표**

- **식별자는 예약어와 동일하게 작성하지 않음**

- **단 클래스, 구조체, 코드 파일은 대문자로 시작**

```swift
//클래스
class Main ... {}
//구조체
struct Main ...{}
//파일
MainViewController.swift
```

- **가독성 위해 한줄에 하나의 문장을 우선시 하기**

- **주석은 설명하려는 구문에 맞춰 들여쓰기**

하나의 의미 단위에 반드시 하나 이상의 주석 작성

```swift
// Good
function someFunction() {
...

//statement에 관한 주석
statements
}
```

- **연산자 사이에는 공백을 추가하여 가독성 높이기**

```swift
a+b+c+d // bad
a + b + c + d //good
```

- **콤마 다음에 값이 올 경우 공백을 추가하여 가독성 높이기**

```swift
var arr = [1,2,3,4] //bad
var arr = [1, 2, 3, 4] //good
```

- ViewController 파일 이름은 VC로 통일한다.

---

### Commit 컨벤션

- **feat**: 새로운 기능 추가
- **fix**: 버그 수정
- **docs**: 문서 변경 (예: README 수정)
- **style**: 코드 포맷팅, 세미콜론 누락 등 비즈니스 로직에 영향을 주지 않는 변경
- **refactor**: 코드 리팩토링
- **test**: 테스트 추가 또는 기존 테스트 수정
- 🔧: 빌드 프로세스 또는 보조 도구와 관련된 변경 (예: 패키지 매니저 설정)

---

## iOS

### 브랜치 구조

```
├── main
└── Dev ────── Release
     ├── Auth       └── version 1.0.0
     ├── Home
     ├── CSearch
     └── Review
			
```

## 폴더링

```
├── Derived
│   ├── InfoPlists
│   └── Sources
│       ├── Extensions
│       └── Fonts
├── DropDrug
│   ├── Resources
│   │   ├── Assets.xcassets
│   │   └── Preview Content
│   ├── Sources
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   ├── APIServices
│   │   ├── Models
│   │   ├── Cells
│   │   ├── Extensions
│   │   ├── ViewControllers
│   │   └── Views
│   └── Tests
│       └── DropDrugTests.swift
├── DropDrug.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   ├── xcshareddata
│   │   └── xcschemes
│   └── xcuserdata
├── DropDrug.xcworkspace
│   ├── contents.xcworkspacedata
│   ├── xcshareddata
│   └── xcuserdata
├── Project.swift
├── README.md
└── Tuist
    ├── Config.swift
    ├── Package.resolved
    └── Package.swift

```
