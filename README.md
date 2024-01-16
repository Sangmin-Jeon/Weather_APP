# Weather_APP
* OpenWeather API를 활용하여 현재 지역의 날씨정보를 표시합니다.   
   
<img src="https://github.com/Sangmin-Jeon/Weather_APP/assets/59474775/07a8e868-34b1-4bb7-8987-2855751d889e.gif" height=500 >  <img src="https://github.com/Sangmin-Jeon/Weather_APP/assets/59474775/5284fce6-5a6e-4b6c-a3d0-6527318df37e.gif" height=500 >

## Description   
   
* **개인 프로젝트**

* **Tech/framework used**
    * Language: `Swift`
    * Framework: `UIKit`
    * Library: `RxSwift` `Alamofire` `SnapKit` `Kingfisher` `Charts` `lottie-ios`

* 구현한 내용
    1. OpenWeather API연동을 위한 네트워크연동 모듈 코드 구현
    * 서버연동 모듈
    해당 모듈은 `Alamofire` 라이브러리를 이용하여 구현하였습니다. `OpenWeather API`와의 통신을 각**View**의 **ViewModel**에서 **Singleton** 인스턴스를 생성하여
    간편하게 재사용 할 수 있게 **Generics타입**으로 **HTTP메소드**들에 따라 함수를 구현하였고 API 요청은 `RxSwift`를 사용하여 비동기 처리 하였습니다.
    이를 통해 네트워크 요청의 시작과 완료, 에러 처리를 간결하게 관리할 수 있게 하였고, `RxSwift`의 **Observable**은 앱에서 네트워크 통신시 발생하는
    다양한 비동기 작업들을 쉽고 효율적으로 관리하는데 도움을 주었습니다.
    모듈은 **Singleton 패턴**을 사용하여 하나의 인스턴스만을 생성하여 리소스의 효율적인 사용을 가능하게 하였습니다.
    또한, 모듈은 **Generics 타입**과 **Codable 프로토콜**을 이용하여 데이터 파싱을 처리함으로서 API 요청의 응답데이터를 모델 객체로 변환할 수 있습니다.
    API 연동 모듈을 구현하면서 `Alamofire` 라이브러리는 `URL 세션`을 추상화하여 사용하기 쉽고, 효과적인 API를 제공하였고, 이를 사용하여 
    요청을 생성하고, 요청의 성공 및 실패처리하는 코드를 간결하게 작성할 수 있었습니다.
    결과적으로 해당 모듈은 앱에서 필요한 데이터를 서버에 전달하고 요청 결과를 RxSwift를 통해 쉽게 처리 할 수 있습니다.  
    
    * 네트워크 통신 모듈
    https://github.com/Sangmin-Jeon/Weather_APP/blob/7449583f2f8f5f393b5c5b5d2611f5e87975de79/Weather_APP/Net/NetworkManager.swift#L7-L57  
    
    * API Key 보안 관리
    `openWeather`에서 발급받은 개인 **API Key**를 보안하기 위해 `.xcconfig`를 사용하였습니다.
    `.xcconfig` 파일안에 발급받은 key를 환경변수로 정의하였고 프로젝트의 `info.plist`에 저장하였습니다. 이렇게 코드 내에 직접 작성하지 않아도
    필요할때 호출하여 사용할 수 있게 구현하였습니다. 또한 `.gitignore`에 `.xcconfig`파일을 추가하여 Push할때 **API Key**정보가 포함되지 않도록 하여
    **GitHub**에서 소스 코드를 공개하여도 **API Key**를 외부에 노출되지 않도록 하였습니다.
    API Key는 API호출시 간편하게 사용할 수 있게 **APIManager**라는 **Singleton객체**로 구현하였습니다.  
    
    2. 현재 날씨 표시      
    [OpenWeather API](https://openweathermap.org/current) 를 사용해서 앱 실행시 `GPS`정보를 활용하여 현재 지역에 대한 `위도`, `경도`값을 받아와 실시간으로 현재 날씨정보를 표시
    사용자의 현재 위치 정보를 CoreLocation 프레임워크를 사용하여 가져옵니다. 위치 정보는 CLLocationManager 객체를 통해 얻습니다.
    기온의 경우 API 응답 데이터에서는 절대온도로 받아오기 때문에 절대온도를 섭씨온도 변환해주는 공통 모듈을 별도로 구현하여 View에 표시해주었습니다.  
    
    * 절대 온도, 섭씨 온도 변환
    https://github.com/Sangmin-Jeon/Weather_APP/blob/7449583f2f8f5f393b5c5b5d2611f5e87975de79/Weather_APP/Common/Double_Extension.swift#L9-L16  
    
    * GPS정보 받아오기
    https://github.com/Sangmin-Jeon/Weather_APP/blob/7449583f2f8f5f393b5c5b5d2611f5e87975de79/Weather_APP/ViewController.swift#L84-L105
    최상위 ViewController 객체인 **ViewController**에서 구현하여 **ViewController**를 상속받는 모든 ViewController에서 사용 가능하도록
    구현하였고 위치 정보의 변화를 감지하여 앱 내에서 반영하는 것은 RxSwift를 통해 비동기적으로 처리 하였습니다.
    이를 통해 앱 내에서 사용자의 위치 정보가 변경될 때마다 이를 감지하고 위치에 대한 최신 날씨 정보를 사용자에게 제공 할 수 있게하였습니다.  
    
    * API 호출
    https://github.com/Sangmin-Jeon/Weather_APP/blob/7449583f2f8f5f393b5c5b5d2611f5e87975de79/Weather_APP/View/MainViewController.swift#L272-L293  
    
    * 에러 처리
    API 요청 실패시 해당 에러 내용에따라 Alert을 표시해주었습니다.
    추 후 Alert이벤트에 따라 에러 처리를 할 수 있게 구현 하였고 Alert 팝업의 경우 앱 전반적으로 어디에서든 
    공용으로 사용할 수 있게 공통 모듈로 처리 하였습니다.  
    
    3. 5일간 시간대별 날씨 정보        
    * [OpenWeather API](https://openweathermap.org/forecast5) `5일간 3시간` 간격으로 의 날씨정보를 가져옵니다. 일자로 구분되어 해당 날짜의 `최고`, `최저` 기온을 보여줍니다.
    사용자의 현재 위치 정보를 기반으로 `OpenWeatherMap API`를 통해 날씨 정보를 가져옵니다. 이 정보는 **MainViewModel**을 통해 가져오고, **MainViewController**에서 표시합니다.
    해당 기능을 구현하기 위해 **구조체**와 `HashTable`를 사용하여 데이터를 구조화 하였습니다.
    Cell에 표시해주기 위한 날짜를 **Key**값으로 사용하였고 해당 날짜에 대한 상세 데이터를 상세화면으로 가져가기 위해서
    **Value**값에 배열로 상세 데이터를 저장하는 방식으로 구현하였습니다.
    데이터를 처리해주는 로직은 해당 **View**의 **ViewModel**에서 구현하였고 가공된 데이터를 View에서 `RxDataSources`프레임 워크를 사용해서
    기존의 **Delegate패턴**을 사용하지 않고 Rx로 비동기 처리하였습니다.  
    
    * 날씨 데이터 바인딩
    https://github.com/Sangmin-Jeon/Weather_APP/blob/7449583f2f8f5f393b5c5b5d2611f5e87975de79/Weather_APP/View/MainViewController.swift#L293-L337  
    
    4. 일간 날씨 정보 상세 화면
    * Charts View 구현
    `Charts` 라이브러리를 사용하여 날씨 데이터를 선형 차트 형식으로 표시하는 할 수 있게 세팅하는 함수를 구현하였습니다.
    함수를 통해 차트에 표시할 데이터 및 UI정보를 설정하고, 각 데이터 포인트는 `TemperatureData`타입의 배열로부터 추출 합니다.  
    
    * Charts 데이터 세팅
    https://github.com/Sangmin-Jeon/Weather_APP/blob/7449583f2f8f5f393b5c5b5d2611f5e87975de79/Weather_APP/View/DetailViewController.swift#L223-L278

    * 데이터 세팅
    온도와 압력을 선택해서 표시 할 수 있게하기 위해 `menuType`이라는 **enum타입**을 별도로 생성하였고 해당 값을 `ChartDataEntry`로 변환 하였습니다.
    이 변환된 데이터를 추가하여 차트에 표시합니다. 이를 통해 사용자는 시간대별 온도 또는 압력에 대한 정보를 직관적으로 이해할 수 있게 하였습니다.
    차트의 UI는 `LineChartDataSet` 객체를 사용해서 설정하였는데 이 객체를 통해 데이터의 **색상, 마커, 선의 유형, 배경색 등의** UI설정을
    구현하였습니다.

    * 축 정보 세팅
    X축은 각 시간들을 순서대로 표시하고 Y축에는 시간대별 데이터의 값들을 표시해주었습니다.
    X축의 시간들은 API 요청시 받아온 응답 데이터에서 시간을 추출하여 해당 시간값을 `DateFormatter`를 사용해서 원하는
    형식으로 변환하여 `Chart`에 표시해 주었습니다.
    변환해 주는 함수같은 경우 `String`입에서 어디에서든 사용 할 수 있게 `Extention`으로 빼서 공통 모듈로 구현하였습니다.  
    
    * 해당 시간을 터치시 마커를 사용해서 포인트에 정보를 좀더 정확히 볼 수 있도록 마커를 추가하였습니다.  
    
    * 시간대별 날씨 및 기온
    차트와 별도로 시간대별 날씨 정보를 `CollectionView`를 사용해서 표시 해주었습니다.
    날씨 icon같은 경우 `OpenWeather API`에서 기본으로 제공해주는 icon을 사용하였고 API호출 시 응답 데이터로 받은 icon 키워드를
    `URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")` 같이 받아와 이미지를 캐싱하여
    Cell에 표시해주었습니다.
    이 부분은 Cell의 크기를 설정해주기 위해서 `RxDataSources`와 `Delegate패턴`을 같이 사용하여 구현하였습니다.

   * TODO
   1. 대기 정보 표시
 
    
