//
// Copyright 2026 Evolving Legacy LLC.
//
// SPDX-License-Identifier: AGPL-3.0-only.
// Please see LICENSE files in the repository root for full details.
//

@testable import ElementX

extension AppSettings {
    /// Evolve Chat ships locked to chat.evolveestatesgroup.ai with other servers disallowed. Tests of Element's
    /// generic account-provider logic call this first so they run against Element's stock provider settings.
    func useElementStockAccountProviders() {
        override(accountProviders: [.managed(serverName: "matrix.org", baseURL: "https://matrix-client.matrix.org")],
                 allowOtherAccountProviders: true,
                 hideBrandChrome: false,
                 pushGatewayBaseURL: pushGatewayBaseURL,
                 oAuthRedirectURL: oAuthRedirectURL,
                 oAuthClientURIPath: oAuthClientURIPath,
                 websiteURL: websiteURL,
                 logoURL: logoURL,
                 copyrightURL: copyrightURL,
                 acceptableUseURL: acceptableUseURL,
                 privacyURL: privacyURL,
                 encryptionURL: encryptionURL,
                 deviceVerificationURL: deviceVerificationURL,
                 chatBackupDetailsURL: chatBackupDetailsURL,
                 identityPinningViolationDetailsURL: identityPinningViolationDetailsURL,
                 historySharingDetailsURL: historySharingDetailsURL,
                 elementWebHosts: elementWebHosts,
                 accountProvisioningHost: accountProvisioningHost,
                 bugReportApplicationID: bugReportApplicationID,
                 analyticsTermsURL: analyticsTermsURL,
                 mapTilerConfiguration: mapTilerConfiguration.publisher.value)
    }
}
