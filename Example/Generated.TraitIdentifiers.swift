import Traits

enum TraitIdentifier {
		case containerView
		case backgroundView
		case titleLabel
		case childView
		case childViewWidth
		case childViewHeight
		case titleLabelLeading
		case titleLabelTop

		private var entry: TraitIdentifierEntry {
			switch self {
				case .containerView:
					return TraitIdentifierEntry("containerView", classes: [UIView.self])
				case .backgroundView:
					return TraitIdentifierEntry("backgroundView", classes: [UIView.self])
				case .titleLabel:
					return TraitIdentifierEntry("titleLabel", classes: [UILabel.self])
				case .childView:
					return TraitIdentifierEntry("childView", classes: [UIView.self])
				case .childViewWidth:
					return TraitIdentifierEntry("childView.width", classes: [NSLayoutConstraint.self])
				case .childViewHeight:
					return TraitIdentifierEntry("childView.height", classes: [NSLayoutConstraint.self])
				case .titleLabelLeading:
					return TraitIdentifierEntry("titleLabel.leading", classes: [NSLayoutConstraint.self])
				case .titleLabelTop:
					return TraitIdentifierEntry("titleLabel.top", classes: [NSLayoutConstraint.self])
			}
		}

		var identifier: String { return self.entry.identifier }
}

extension TraitsProvider.Specification {
    init(typedSpec: [TraitIdentifier: [Trait]]) {
        var dict = [String: [Trait]]()

        _ = typedSpec.map { identifier, list in
            dict[identifier.identifier] = list
        }

        self.init(specs: dict)
    }
}
