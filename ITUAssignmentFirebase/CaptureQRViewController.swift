//
//  CaptureQRViewController.swift
//  ITUQRCode
//
//  Created by Yutthapong Kawunruan on 11/16/22.
//

import AVFoundation
import UIKit
import FirebaseDatabase

class CaptureQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var cameraView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getCameraPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddContactViewController, let contact = sender as? ContactViewModel {
            vc.contact = contact
        }
    }
    
    @IBAction func backTapped() {
        self.dismiss(animated: true)
    }
    
    func getCameraPreview() {
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer) // add preview layer to your view
        captureSession.startRunning() // start capturing
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning() // stop scanning after receiving metadata output
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let codeString = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.receivedCode(qrcode: codeString)
        }
    }
    
    func receivedCode(qrcode: String) {
        print(qrcode)
        
        let encodeString = qrcode.removingPercentEncoding!
        
        lazy var contactRef: DatabaseReference = {
          let ref = Database.database()
            .reference()
            .child(encodeString)
          return ref
        }()
        
        print(contactRef)
        
        contactRef.observe(.value) { [weak self] (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let key = snapshot.key
                let viewModel = ContactViewModel(key: key, dict: dict)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.performSegue(withIdentifier: "shoeAddContactPage", sender: viewModel)
                }
            } else {
                print("No contact data")
            }
        }
    }
    
    func showQRCodeAlert(qrcode: String) {
        
        let ac = UIAlertController(title: "QR Code Founded", message: qrcode, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(ac, animated: true)
        captureSession = nil
    }
}
