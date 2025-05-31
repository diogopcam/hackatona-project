import Foundation

class AudioFileManager {
    static let shared = AudioFileManager()
    
    private let userDefaults = UserDefaults.standard
    private let recordedAudiosKey = "RecordedAudios"
    
    private init() {}
    
    // MARK: - Save recorded audio
    func saveRecordedAudio(fileName: String) {
        var savedAudios = getRecordedAudios()
        if !savedAudios.contains(fileName) {
            savedAudios.append(fileName)
            userDefaults.set(savedAudios, forKey: recordedAudiosKey)
        }
    }
    
    // MARK: - Get recorded audios
    func getRecordedAudios() -> [String] {
        return userDefaults.stringArray(forKey: recordedAudiosKey) ?? []
    }
    
    // MARK: - Get sample audio files for mock data
    func getSampleAudioFiles() -> [String] {
        let recordedFiles = getRecordedAudios()
        
        // Se temos arquivos gravados, use-os
        if !recordedFiles.isEmpty {
            return recordedFiles
        }
        
        // Caso contrário, crie alguns arquivos de exemplo
        return createSampleAudioFiles()
    }
    
    // MARK: - Create sample audio files
    private func createSampleAudioFiles() -> [String] {
        let sampleFiles = [
            "feedback_lideranca.m4a",
            "feedback_comunicacao.m4a", 
            "feedback_participacao.m4a",
            "elogio_tecnico.m4a",
            "feedback_engajamento.m4a",
            "feedback_criatividade.m4a"
        ]
        
        // Criar arquivos de exemplo vazios (simulação)
        for fileName in sampleFiles {
            let documentsPath = getDocumentsDirectory()
            let filePath = documentsPath.appendingPathComponent(fileName)
            
            // Criar arquivo vazio se não existir
            if !FileManager.default.fileExists(atPath: filePath.path) {
                // Criar um arquivo de áudio mínimo (dados vazios por enquanto)
                try? Data().write(to: filePath)
            }
        }
        
        // Salvar no UserDefaults
        userDefaults.set(sampleFiles, forKey: recordedAudiosKey)
        
        return sampleFiles
    }
    
    // MARK: - Check if audio file exists
    func audioFileExists(fileName: String) -> Bool {
        let documentsPath = getDocumentsDirectory()
        let filePath = documentsPath.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    // MARK: - Get audio file URL
    func getAudioFileURL(fileName: String) -> URL? {
        let documentsPath = getDocumentsDirectory()
        let filePath = documentsPath.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            return filePath
        }
        return nil
    }
    
    // MARK: - Get documents directory
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Get random audio file for mock data
    func getRandomAudioFile() -> String? {
        let availableFiles = getSampleAudioFiles()
        return availableFiles.randomElement()
    }
    
    // MARK: - List all audio files
    func listAllAudioFiles() -> [String] {
        let documentsPath = getDocumentsDirectory()
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsPath.path)
            return files.filter { $0.hasSuffix(".m4a") }
        } catch {
            print("Erro ao listar arquivos: \(error)")
            return []
        }
    }
}
