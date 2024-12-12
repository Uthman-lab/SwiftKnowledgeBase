//
//  File.swift
//  AddToContact
//
//  Created by AMALITECH-PC-593 on 12/9/24.
//

import Foundation
import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }
        return createBuildCommands(
            inputFiles: sourceTarget.sourceFiles(withSuffix: "swift").map(\.path),
            packageDirectory: context.package.directory,
            workingDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint")
        )
    }

    private func createBuildCommands(
        inputFiles: [Path],
        packageDirectory: Path,
        workingDirectory: Path,
        tool: PluginContext.Tool
    ) -> [Command] {
        if inputFiles.isEmpty {
            return []
        }

        var arguments = [
            "lint",
            "--quiet",
            "--force-exclude",
            "--cache-path", "\(workingDirectory)"
        ]

        if let configuration = packageDirectory.firstConfigurationFileInParentDirectories() {
            arguments.append(contentsOf: ["--config", "\(configuration.string)"])
        }
        arguments += inputFiles.map(\.string)

        let outputFilesDirectory = workingDirectory.appending("Output")

        return [
            .prebuildCommand(
                displayName: "SwiftLint",
                executable: tool.path,
                arguments: arguments,
                outputFilesDirectory: outputFilesDirectory
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let inputFilePaths = target.inputFiles
            .filter { $0.type == .source && $0.path.extension == "swift" }
            .map(\.path)
        return createBuildCommands(
            inputFiles: inputFilePaths,
            packageDirectory: context.xcodeProject.directory,
            workingDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint")
        )
    }
}
#endif
