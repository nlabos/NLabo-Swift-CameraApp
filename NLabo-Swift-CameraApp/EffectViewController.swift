//
//  EffectViewController.swift
//  NLabo-Swift-CameraApp
//
//  Created by 髙津悠樹 on 2022/09/27.
//

import UIKit

class EffectViewController: UIViewController {
    
    //何も加工していない撮影した時の画像
    var originalImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        effectImageView.image = originalImage
    }
    @IBOutlet weak var effectImageView: UIImageView!
    
    var filterName = Filter.Mono
    
    @IBAction func effectButtonAction(_ sender: Any) {
        //エフェクト前の画像をアンラップして取り出す
        if let image = originalImage {
            //フィルター名を指定する(第3回で関数の外に出します)
            //let filterName = "CIPhotoEffectMono"
            
            //フィルター名を指定する
            filterName.next()
            
            //元々の画像の回転角度を取得する
            let rotate = image.imageOrientation
            
            //UIImage型の画像をCIImage型に変換する
            let inputImage = CIImage(image: image)
            
            //フィルターの種類を引数で指定されたものに指定してCIFilterインスタンスを取得する
            guard let effectFilter = CIFilter(name: filterName.rawValue) else {
                return
            }
            //エフェクトのパラメータを初期化
            effectFilter.setDefaults()
            
            //インスタンスにエフェクトをつける元画像を設定
            effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
            
            //エフェクトを適用したCGImage型の画像を取得
            guard let outputImage = effectFilter.outputImage else {
                return
            }
            
            //CIContextのインスタンスを取得
            let ciContext = CIContext(options: nil)
            
            //エフェクト後の画像をCIContext上に描画し、結果をCGImage型で取得する
            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                return
            }
            
            //CGImage型からUIImage型に変換、回転角度を指定して表示
            effectImageView.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
            
        }
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any){
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func shareActionButton(_ sender: Any) {
        //表示画像をアンラップしてシェアする画像を取り出す
        if let shareImage = effectImageView.image {
            //UIActivityViewControllerに渡す配列を作成
            let shareItems = [shareImage]
            //UIActivityViewControllerにシェア画像を渡す
            let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            //UIActivityViewControllerを表示
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    enum Filter: String {
        case Mono = "CIPhotoEffectMono"
        case Insert = "CIPhotoEffectInstant"
        case Process = "CIPhotoEffectProcess"
        case Transfer = "CIPhotoEffectTransfer"
        case Sepia = "CISepiaTone"
        
        static let values = [Mono, Insert, Process, Transfer, Sepia]
        mutating func next() {
            let val = (Filter.values.firstIndex(of: self)! + 1) % Filter.values.count
            self = Filter.values[val]
        }
    }
    
    


}
