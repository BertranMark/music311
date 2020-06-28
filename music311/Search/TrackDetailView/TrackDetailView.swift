//
//  TrackDetailView.swift
//  music311
//
//  Created by Bertran on 02.06.2020.
//  Copyright © 2020 Bertran. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    
    
    @IBOutlet weak var trackImageView: UIImageView!


    @IBOutlet weak var currentTimeSlider: UISlider!

    @IBOutlet weak var currentTimeLabel: UILabel!

    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var trackTitleLabel: UILabel!

    @IBOutlet weak var authorTitleLabel: UILabel!

    @IBOutlet weak var playPauseButton: UIButton!
    
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        // по умолчанию присутствует задержка пока он загрузится, эта настройка позволяет снизить задержку до минимума
        return avPlayer
    }()

     // MARK: - Aawake
    
    override func awakeFromNib() {
           super.awakeFromNib()
        
        let scale : CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        trackImageView.clipsToBounds = true
       }
   
     // MARK: - Setup
    
    func set(viewModel: SearchViewmodel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTtime()
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        observe0layerCurrentTime()
        
    }
    
    private func playTrack(previewUrl: String?) {
       
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    // MARK: - Time Setup
    
    private func monitorStartTtime() {
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImage()
        }
        // какое-то подобие таймера в одну секунду, то есть через одну секунду как запустился плейер - увеличить картинку. Что значат параметры таймера - не понятно, он не объяснил, объяснения были в уроке 31.16 на 11 минуте. ПОПРОБОВАТЬ РАЗОБРАТЬСЯ. Цель этой функции - как только открывается окно и плеер начинает играть - увеличить картинку
    }
    
    private func observe0layerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        // хотим чтобы таймер срабатывал каждую секунду
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = currentDurText
        }
    }
    
    // MARK: - Animations
    
    private func enlargeTrackImage() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.trackImageView.transform = .identity
            
        }, completion: nil)
    }
    
    private func reduceTrackImage() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
           let scale : CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }, completion: nil)
    }
    
    // MARK: - @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }

    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }

    @IBAction func previousTrack(_ sender: Any) {
    }

    @IBAction func nextTrack(_ sender: Any) {
    }

    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "Button Pause"), for: .normal)
            enlargeTrackImage()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "Button Next"), for: .normal)
            reduceTrackImage()
        }
        
    }
    
}
