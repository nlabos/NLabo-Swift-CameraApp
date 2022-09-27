//
//  ViewController.swift
//  NLabo-Swift-CameraApp
//
//  Created by 髙津悠樹 on 2022/09/27.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //画面遷移時に次の画面に渡す画像
    var captureImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBAction func cameraButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //撮影後に呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //ここは第二回でコメントアウト
        //pictureImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "showEffectView", sender: nil)
        })
    }
    
    //画面遷移するときに画像を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? EffectViewController {
            nextViewController.originalImage = captureImage
        }
    }


}

