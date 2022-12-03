## Velance, 2021 제 9회 K-해커톤 앱개발 챌린지 우수상 수상작 (한국컴퓨터정보학회장상)

## 기술

- MVVM (Delegate 패턴 기반)
- UIKit, Storyboard
- Alamofire(REST API)

## iOS 2 / 백엔드 1 / 디자인,기획 1

## 담당 역할과 업무

- iOS 2명 중 하나
- 앱의 50% 담당
    - 커뮤니티 탭
    - 식당찾기 탭

## 주요 기능

- 채식 메뉴를 판매하는 **식당 정보 제공**
- 입맛/선호메뉴에 따른 **맞춤형 식당 추천** 기능
- 알러지/입맛에 따른 **맞춤형 채식제품 및 레시피 추천** 기능
- 비슷한 관심사/취미를 가진 채식자들과 소통할 수 있는 **커뮤니티 제공**

## 스크린샷

비슷한 관심사/취미를 가진 채식자들과 소통할 수 있는 커뮤니티

![image](https://user-images.githubusercontent.com/52317025/205428117-0449880e-3b8e-4f29-86d2-138d1aeec52b.png)

채식 메뉴를 판매하는 식당 정보

![image](https://user-images.githubusercontent.com/52317025/205428120-a991b6b1-5c06-4125-898a-a15e522ab2a7.png)

사용자의 입맛과 알러지 정보에 맞춘 비건 제품 추천

![image](https://user-images.githubusercontent.com/52317025/205428127-f4414c71-f42e-4983-a749-63721e9f5f3d.png)

## 프로젝트 진행 때 어려웠던 점

**커스텀 UI**

- 디자이너가 원하는 앱 디자인을 반영하기 위해 CALayer, CAGradientLayer 등을 이용해서 커스텀한 컴포넌트를 만들어 사용했음.
- UIKit에 비해 Core Animation은 사용이 어려워서 시간을 많이 쏟았음

**복잡한 Collection View 구성**

- 좌우로 스크롤되는 콜렉션 뷰가 상단에 있고 또 하단에는 상하로 스크롤되는 콜렉션 뷰를 구성해야 했었는데 이렇게 복잡한 뷰는 처음이었어서 꽤 시간이 소모되었음

**MVVM패턴 첫 사용**

- ViewModel의 역할은 개념으로 배웠었지만 ViewModel과 ViewController 사이 정보 전달을 구현하기 어려웠었음
- Delegate Pattern과 ViewModel을 직접 ViewController에서 호출하는 방법으로 ViewModel의 output과 input 정보를 전달했음
