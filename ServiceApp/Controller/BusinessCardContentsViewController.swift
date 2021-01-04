/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller for identified business cards.
*/

import UIKit
import Vision

class BusinessCardContentsViewController: UITableViewController {
    static let tableCellIdentifier = "businessCardContentCell"

    typealias CardContentField = (name: String, value: String)
    
    var numbers : String = ""

    /// The information to fetch from a scanned card.
    struct BusinessCardContents {
        
        var name: String?
        var numbers = [String]()
        
        func availableContents() -> [CardContentField] {
            var contents = [CardContentField]()
     
            if let name = self.name {
                contents.append(("Name", name))
            }
            numbers.forEach { (number) in
                contents.append(("Number", number))
            }
            
            return contents
        }
    }
    
    var contents = BusinessCardContents()
}

// MARK: UITableViewDataSource
extension BusinessCardContentsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.availableContents().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = contents.availableContents()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:
            BusinessCardContentsViewController.tableCellIdentifier, for: indexPath)
        cell.textLabel?.text = field.name
        cell.detailTextLabel?.text = field.value
        
        print("\(field.name) - \(field.value)")
        if field.value.count > 8 {
            for i in field.value {
                if i == "-" {
                    print("Product number: \(field.value)")
                }
            }
        }
        
        return cell
    }
}

// MARK: RecognizedTextDataSource
extension BusinessCardContentsViewController: RecognizedTextDataSource {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        // Create a full transcript to run analysis on.
        var fullText = ""
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            fullText.append(candidate.string + "\n")
        }
        parseTextContents(text: fullText)
        tableView.reloadData()
        navigationItem.title = contents.name != nil ? contents.name : "Scanned Card"
    }
    
    // MARK: Helper functions
    func parseTextContents(text: String) {
        do {
            
            // Create an NSDataDetector to parse the text, searching for various fields of interest.
            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
            let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
            for match in matches {
                let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                let matchedString = String(text[matchStartIdx..<matchEndIdx])
            
                switch match.resultType {
                case .phoneNumber:
                    contents.numbers.append(matchedString)
                default:
                    print("\(matchedString) type:\(match.resultType)")
                }
            }
        } catch {
            print(error)
        }
    }
}
