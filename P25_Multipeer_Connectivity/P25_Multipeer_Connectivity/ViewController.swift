//
//  ViewController.swift
//  P25_Multipeer_Connectivity
//
//  Created by Laura on 31.08.2022..
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {

    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)           // how peer (person) is shown on other devices - get the name of current device
    var mcSession: MCSession?
    var advertiser: MCNearbyServiceAdvertiser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selfie Share"
        
        let importPictureBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let sendMessageBtn   = UIBarButtonItem(title: "Chat", style: .plain, target: self, action: #selector(sendMessage))
        navigationItem.rightBarButtonItems = [importPictureBtn, sendMessageBtn]
        
        let peerConnectedBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let showPeersBtn     = UIBarButtonItem(title: "Peers", style: .plain, target: self, action: #selector(showConnectedPeers))
        navigationItem.leftBarButtonItems = [peerConnectedBtn, showPeersBtn]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self      // tell us when something happened
    }
    
    func startHosting(action: UIAlertAction) {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "laura-project25")
        advertiser!.startAdvertisingPeer()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "laura-project25", session: mcSession)
        mcBrowser.delegate = self       // vc is delegate of mcSession and mcBrowser
        present(mcBrowser, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]                    // load image from array and put it in imageView image
        }
        
        return cell
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }        // if we can't find image in dict
        dismiss(animated: true)                                                 // dismiss vc
        
        images.insert(image, at: 0)                                             // insert image in array
        collectionView.reloadData()                                             // show it
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                
                // Send image data
                try? mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)  // reliable - will always get there
            }
        }
    }
    
    @objc func sendMessage() {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            let ac = UIAlertController(title: "Send message", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Send", style: .default) { action in
                guard ac.textFields?[0].text?.count != 0 else { return }
                
                let stringToSend = mcSession.myPeerID.displayName + ": " + (ac.textFields?[0].text)!
                let stringData = Data(stringToSend.utf8)
                
                // Send string data
                try? mcSession.send(stringData, toPeers: mcSession.connectedPeers, with: .reliable)
            })
        }

    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func showConnectedPeers() {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count == 0 {
            let ac = UIAlertController(title: "There are no connected peers to this network.", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            var peers = ""
            
            for (index, peer) in mcSession.connectedPeers.enumerated() {
                peers += "\(index + 1). " + peer.displayName + "\n"
            }
            
            let ac = UIAlertController(title: "Connected Peers", message: peers, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)              // accepts every connection
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            let ac = UIAlertController(title: nil, message: "\(peerID.displayName) has disconnected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            
        @unknown default:
            print("Uknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)       // insert into images array
                self?.collectionView.reloadData()
            } else {
                let message = String(decoding: data, as: UTF8.self)
                
                let ac = UIAlertController(title: "Message Received", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
}

