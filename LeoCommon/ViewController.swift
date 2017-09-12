//
//  ViewController.swift
//  LeoCommon
//
//  Created by 李理 on 2017/6/5.
//  Copyright © 2017年 李理. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Alamofire
import RxCocoa
import RxGesture

extension UIView {
    func tap() -> Observable<UITapGestureRecognizer> {
        let result = self.rx.tapGesture{ (gestureRecognizer, delegate) in
            delegate.simultaneousRecognitionPolicy = .never
        }.when(UIGestureRecognizerState.recognized)
        return result
    }
}

public class SYDApi<Base> {
    public let base: Base //等升级Swift4.0以后，请把这里可以改为private，extension中依然可以访问，但其他外部无法访问
    public init(_ base: Base) {
        self.base = base
    }
    deinit {
        print("SYDApi释放罗...")
    }
}

extension SYDApi where Base: SYDDemo {
    func sayHello() {
        print("Hello")
    }
}

extension SYDDemo {
    public var syd: SYDApi<SYDDemo> {
        return SYDApi(self)
    }
}


class SYDDemo {
    deinit {
        print("Demo释放罗...")
    }
}

extension SYDDemo {
    public func rx_autoUpdater(source: Observable<ArrayChangeEvent>) -> Disposable {
        return source.scan((0, nil)) { (a: (Int, ArrayChangeEvent?), ev) in
            return (a.0 + ev.insertedIndices.count - ev.deletedIndices.count, ev)
        }.observeOn(MainScheduler.instance).bind(onNext: { sourceCount, event in
            print("===")
        })
    }
}

class Item {
    
}

class Section {
    var items:ObservableArray<Item> = []
}

extension UIView {
    func tapGesture() -> Observable<UITapGestureRecognizer> {
        let result = self.rx.tapGesture{ (gestureRecognizer, delegate) in
            delegate.simultaneousRecognitionPolicy = .never
        }.when(UIGestureRecognizerState.recognized)
        return result
    }
}

class ViewController: UIViewController, APIDelegate, UIGestureRecognizerDelegate {
    
    private var api:API!
    
    var button:UIButton = UIButton();
    
    private var disposeBag = DisposeBag()
    private var sectionInnerDisposeBag = DisposeBag()
    
    var sections:ObservableArray<Section> = []
    
    var items:[Int] = [] {
        didSet {
            print("----------")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sections.rx_elements().bind { (sectionVMS) in
            self.sectionInnerDisposeBag = DisposeBag()
            
            for sectionVM in sectionVMS {
                sectionVM.items.rx_elements().skip(1).bind(onNext: { (cellVMS) in
                    print("某个Section发生改变...")
                }).addDisposableTo(self.sectionInnerDisposeBag)
            }
            
            print("发生改变...")
        }.addDisposableTo(self.disposeBag)
        
        let view = UIView()
        view.backgroundColor = .red
        view.frame = .init(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(view)
        
        _ = view.tapGesture().bind { (_) in
//            self.sections[0].items.append(Item())
//            self.items.append(1)
            self.items.insert(self.items.count, at: self.items.count)
            print("点击子视图")
        }
        
        _ = self.view.tapGesture().bind { (_) in
//            self.sections.append(Section())
            if self.items.count > 0 {
//                self.items.remove(at: 0)
                self.items[0] = 2
            }
            print("点击父视图")
        }
        
    }
}

