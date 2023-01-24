# Kurly

![Generic badge](https://img.shields.io/badge/Swift-5.7-orange.svg) ![Generic badge](https://img.shields.io/badge/SwiftUI-2-green.svg)


![demo1](https://user-images.githubusercontent.com/4756783/214218629-e00be26b-8eda-491f-bf40-0df616fc22cf.gif) &emsp; &emsp; ![demo2](https://user-images.githubusercontent.com/4756783/214218636-b87e43e9-a468-47f5-9764-6fb7ffc7fd0c.gif)



<br>

## Features

- GitHub 저장소 검색 
- 최근 검색어 (최대 10개)
- 자동완성 (최근 검색어 중에서 처리)
- 검색 결과 Pagination 
- 화면 (Light, Dark mode)
- 언어 (한글, 영어)

<br>
<br>

## Requirement
- iOS 15
- Xcode 14.2

<br>
<br>

## Getting Started

Preview 를 위해 iPhone 8, iPhone 11 Pro Siumulator 설치가 필요합니다. 

<br>
<br>

## Project

 * **Search**  
   * Search  &emsp; &emsp; &emsp; &emsp;  // Parent View
   * Keywords &emsp; &emsp; &emsp;   // 최근 검색어
   * Autocompletes &ensp; &ensp; // 자동완성
   * Result &emsp; &emsp; &emsp; &emsp; &nbsp;   // 검색결과
   * CoreData &emsp; &emsp; &emsp; &nbsp;// 검색관련 CoreData
    
<br>

 * **Component**
   * Image  &emsp; &emsp; &emsp; &emsp; &ensp; // 비동기 Image 처리
   * Toast &ensp; &ensp; &emsp; &emsp; &emsp; &ensp; // Toast View
   * View &emsp; &emsp; &emsp; &emsp; &nbsp; &ensp;  // SwiftUI View 관련 
    
<br>

 * **Util**
   * Date  &emsp; &emsp; &emsp; &emsp; &emsp;  // 단위 변환과 formattedDate 처리
   * Image &emsp; &emsp; &emsp; &emsp; &nbsp;  // Image cache 등, Image 관련 처리
   * Locale &emsp; &ensp; &ensp; &emsp; &emsp; // LanguageCode, CountryCode, CountryCallingCode 등, Locale 관련 처리
   * Logger &emsp; &emsp; &emsp; &emsp;    // Debug Logger 
   * Network &emsp; &emsp; &emsp; &nbsp; // Network 관련 처리
   * UserDefault &emsp; &emsp;  // UserKeyfault Key 관리
   * Version &emsp; &emsp; &emsp; &ensp; // App Version 관련 처리


<br>
<br>

## Test

 * **Unit**  
   * KurlyTests
    
<br>

 * **UI**
   * KurlyUITests
   * KurlyUITestsLaunchTests

