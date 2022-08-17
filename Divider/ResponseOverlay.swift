//
//  ResponseOverlay.swift
//  Divider
//
//  Created by Bernardo Santiago Marin on 12/06/22.
//

import SwiftUI

struct SavingResponseOverlay: View {
    @ObservedObject var store: Store
    
    var body: some View {
        VStack {
            switch self.store.savingCheckResponseStatus {
            case .success:
                Image(systemName: self.store.savingCheckResponseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.green)
                    .frame(width: 100)
                Text("check_saved_successfully")
            case .doesNotExist:
                Image(systemName: self.store.savingCheckResponseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red)
                    .frame(width: 100)
            case .error:
                Image(systemName: self.store.savingCheckResponseStatus!.rawValue)
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

struct DeletingResponseOverlay: View {
    @ObservedObject var store: Store
    
    var body: some View {
        VStack {
            switch self.store.deletingResponseStatus {
            case .success:
                Image(systemName: self.store.deletingResponseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.green)
                    .frame(width: 100)
                Text("check_deleted_successfully")
            case .doesNotExist:
                Image(systemName: self.store.deletingResponseStatus!.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.orange)
                    .frame(width: 100)
                Text("file_does_not_exist")
            case .error:
                Image(systemName: self.store.deletingResponseStatus!.rawValue)
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

struct SavingResponseOverlay_Previews: PreviewProvider {
    static var previews: some View {
        DeletingResponseOverlay(store: Store())
    }
}
