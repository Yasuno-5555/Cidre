import Foundation

enum WizardStage: String, Codable, CaseIterable, Identifiable {
    case welcome
    case compatibility
    case backupSafety = "backup-safety"
    case diskPlanning = "disk-planning"
    case installPlan = "install-plan"
    case privilegedPreparation = "privileged-preparation"
    case seedGeneration = "seed-generation"
    case artifactPreparation = "artifact-preparation"
    case installExecution = "install-execution"
    case bootChain = "boot-chain"
    case bootPolicy = "boot-policy"
    case postInstallVerification = "post-install-verification"
    case finish
    case uninstallWelcome = "uninstall-welcome"
    case uninstallExport = "uninstall-export"
    case uninstallDiskScan = "uninstall-disk-scan"
    case uninstallTargetReview = "uninstall-target-review"
    case uninstallPlan = "uninstall-plan"
    case uninstallConfirmation = "uninstall-confirmation"
    case uninstallExecution = "uninstall-execution"
    case uninstallVerification = "uninstall-verification"
    case uninstallFinish = "uninstall-finish"
    case repairOverview = "repair-overview"
    case failureScan = "failure-scan"
    case logExport = "log-export"
    case rescueStatus = "rescue-status"
    case recoveryAction = "recovery-action"
    case repairReport = "repair-report"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .welcome:
            return "Welcome"
        case .compatibility:
            return "Compatibility"
        case .backupSafety:
            return "Backup / Safety"
        case .diskPlanning:
            return "Disk Plan"
        case .installPlan:
            return "Install Plan"
        case .privilegedPreparation:
            return "Privileged Preparation"
        case .seedGeneration:
            return "Seed Generation"
        case .artifactPreparation:
            return "Artifact Preparation"
        case .installExecution:
            return "Install Execution"
        case .bootChain:
            return "Boot Chain"
        case .bootPolicy:
            return "Boot Policy"
        case .postInstallVerification:
            return "Post-install Verification"
        case .finish:
            return "Finish"
        case .uninstallWelcome:
            return "Welcome"
        case .uninstallExport:
            return "Export"
        case .uninstallDiskScan:
            return "Disk Scan"
        case .uninstallTargetReview:
            return "Target Review"
        case .uninstallPlan:
            return "Uninstall Plan"
        case .uninstallConfirmation:
            return "Confirmation"
        case .uninstallExecution:
            return "Execution"
        case .uninstallVerification:
            return "Post-uninstall Verification"
        case .uninstallFinish:
            return "Finish"
        case .repairOverview:
            return "Repair Overview"
        case .failureScan:
            return "Failure Scan"
        case .logExport:
            return "Log Export"
        case .rescueStatus:
            return "Rescue Status"
        case .recoveryAction:
            return "Recovery Action"
        case .repairReport:
            return "Repair Report"
        }
    }
}
