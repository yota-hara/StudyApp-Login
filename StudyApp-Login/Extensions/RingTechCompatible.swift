//
//  RingTechCompatible.swift
//  StudyApp-Login
//
//  Created by yotahara on 2023/10/13.
//

import UIKit

// 名前空間rtの定義
public protocol RingTechCompatible {
    associatedtype CompatibleType

    // RingTechの頭文字を取って名前空間にrtと名付ける
    var rt: CompatibleType { get }
}

// Baseに指定した型の引数で変数baseが生成される
public final class RingTech<Base> {
    let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

// RingTechCompatibleを適用したクラスがSelfに入り、戻り値のselfはSelf型の値
public extension RingTechCompatible {
    var rt: RingTech<Self> {
        return RingTech(self)
    }
}

// MARK: - How to Use

/* 使い方
 extension ＜実際の型＞: RingTechCompatible { }

 extension RingTech where Base == ＜実際の型＞ {

     var sample = "名前空間に定義された変数"
 }

 let value = ＜実際の型＞()
 let sampleValue = value.rt.sample
 
 */

/* 例：＜実際の型＞ = Int
 
 extension Int: RingTechCompatible { }

 extension RingTech where Base == Int {

     var isZero: Bool {
         return base == .zero
     }
 }

 let value: Int = 0
 let isZero = value.rt.isZero // false
 
 */

