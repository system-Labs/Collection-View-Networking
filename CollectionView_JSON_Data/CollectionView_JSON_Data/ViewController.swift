//
//  ViewController.swift
//  CollectionView_JSON_Data
//
//  Created by Abdul Sami Sultan on 01/04/2020.
//  Copyright © 2020 Sami. All rights reserved.
//

import UIKit
let apiLink = "/api/heroStats"
let link = "https://api.opendota.com\(apiLink)"
let downloadLink = "https://api.opendota.com"

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class ViewController: UIViewController, UICollectionViewDataSource {
   
    var recivedData = [JsonData]()
    @IBOutlet weak var jsonCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        jsonCollectionView.dataSource = self
        // creating URL session
        let url = URL(string: link)
        
        URLSession.shared.dataTask(with: url!){
            (data, reponse, error) in
            if error == nil{
                do{
                    self.recivedData = try JSONDecoder().decode([JsonData].self, from: data!)
                }catch{
                    print("error while parsing")
                    print(error)
                }
                DispatchQueue.main.async {
                    self.jsonCollectionView.reloadData()
                }
            }
        }.resume()
            
        // Do any additional setup after loading the view.
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recivedData.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: " collectCell", for: indexPath) as! CustomCollectionViewCell
        cell.labelData.text = recivedData[indexPath.row].localized_name.capitalized
        
        
        let completeLink = URL(string: downloadLink + recivedData[indexPath.row].img)
       cell.imageData.load(url: completeLink!)
       
        
        cell.imageData.animationDuration = 10.0
        cell.imageData.clipsToBounds = true
        cell.imageData.layer.cornerRadius = cell.imageData.frame.height / 2
        cell.imageData.contentMode = .scaleToFill
        
        return cell
       }
       

}



