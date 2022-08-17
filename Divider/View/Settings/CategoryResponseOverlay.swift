//
//  CategoryResponseOverlay.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 17/06/22.
//

import SwiftUI

struct CategorySavingResponseOverlay: View {
    var responseStatus: ActionResponse?
    var body: some View {
        VStack {
            switch self.responseStatus {
            case .success:
                Image(systemName: self.responseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.green)
                    .frame(width: 100)
                Text("category_saved_successfully")
            case .doesNotExist:
                Image(systemName: self.responseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.orange)
                    .frame(width: 100)
            case .error:
                Image(systemName: self.responseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red)
                    .frame(width: 100)
                Text("check_saving_error")
            case .none:
                ProgressView()
                    .tint(.accentColor)
            }
        }
        .multilineTextAlignment(.center)
    }
}

struct CategoryDeletingResponseOverlay: View {
    var responseStatus: ActionResponse?
    var body: some View {
        VStack {
            switch self.responseStatus {
            case .success:
                Image(systemName: self.responseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.green)
                    .frame(width: 100)
                Text("category_deleted_successfully")
            case .doesNotExist:
                Image(systemName: self.responseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.orange)
                    .frame(width: 100)
                Text("file_does_not_exist")
            case .error:
                Image(systemName: self.responseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red)
                    .frame(width: 100)
                Text("deleting_error")
            case .none:
                ProgressView()
                    .tint(.accentColor)
            }
        }
        .multilineTextAlignment(.center)
    }
}

struct CategorySavingResponseOverlay_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDeletingResponseOverlay(responseStatus: .error)
    }
}
