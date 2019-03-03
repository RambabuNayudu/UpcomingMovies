//
//  FavoriteMovieCollectionViewCell.swift
//  UpcomingMovies
//
//  Created by Alonso on 3/3/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import UIKit
import Kingfisher

class FavoriteMovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: FavoriteMovieCellViewModel? {
        didSet {
            setupBindables()
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        backdropImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setupLabels()
    }
    
    private func setupLabels() {
        titleLabel.font = FontHelper.bold(withSize: 18.0)
        titleLabel.textColor = ColorPalette.whiteColor
    }
    
    // MARK: - Reactive Behaviour
    
    private func setupBindables() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        backdropImageView.kf.indicatorType = .activity
        backdropImageView.kf.setImage(with: viewModel.backdropURL)
    }

}
