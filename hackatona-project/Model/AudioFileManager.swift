import Foundation

class AudioFileManager {
    static let shared = AudioFileManager()
    
    private let userDefaults = UserDefaults.standard
    private let recordedAudiosKey = "RecordedAudios"
    
    private init() {}
    
    func saveRecordedAudio(fileName: String) {
        var savedAudios = getRecordedAudios()
        if !savedAudios.contains(fileName) {
            savedAudios.append(fileName)
            userDefaults.set(savedAudios, forKey: recordedAudiosKey)
            print("💾 Áudio salvo: \(fileName)")
            print("📋 Total de áudios salvos: \(savedAudios.count)")
        } else {
            print("⚠️ Áudio já existe na lista: \(fileName)")
        }
    }
    
    func getRecordedAudios() -> [String] {
        return userDefaults.stringArray(forKey: recordedAudiosKey) ?? []
    }
    
    func getSampleAudioFiles() -> [String] {
        let recordedFiles = getRecordedAudios()
        
        if !recordedFiles.isEmpty {
            return recordedFiles
        }
        
        return createSampleAudioFiles()
    }
    
    private func createSampleAudioFiles() -> [String] {
        let sampleFiles = [
            "feedback_lideranca.m4a",
            "feedback_comunicacao.m4a", 
            "feedback_participacao.m4a",
            "elogio_tecnico.m4a",
            "feedback_engajamento.m4a",
            "feedback_criatividade.m4a"
        ]
        
        for fileName in sampleFiles {
            let documentsPath = getDocumentsDirectory()
            let filePath = documentsPath.appendingPathComponent(fileName)
            
            if !FileManager.default.fileExists(atPath: filePath.path) {
                try? Data().write(to: filePath)
            }
        }
        
        userDefaults.set(sampleFiles, forKey: recordedAudiosKey)
        
        return sampleFiles
    }
    
    func audioFileExists(fileName: String) -> Bool {
        let documentsPath = getDocumentsDirectory()
        let filePath = documentsPath.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    func getAudioFileURL(fileName: String) -> URL? {
        let documentsPath = getDocumentsDirectory()
        let filePath = documentsPath.appendingPathComponent(fileName)
        
        print("🔍 Verificando arquivo: \(fileName)")
        print("📁 Caminho completo: \(filePath.path)")
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            print("✅ Arquivo existe!")
            
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath.path)
                if let fileSize = attributes[.size] as? Int64 {
                    print("📊 Tamanho do arquivo: \(fileSize) bytes")
                }
            } catch {
                print("⚠️ Erro ao obter atributos do arquivo: \(error)")
            }
            
            return filePath
        } else {
            print("❌ Arquivo não existe!")
            return nil
        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
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
    
    func getMostRecentRecordedAudio() -> String? {
        let recordedFiles = getRecordedAudios()
        
        print("🔍 Buscando áudio mais recente...")
        print("📋 Arquivos gravados disponíveis: \(recordedFiles)")
        
        if recordedFiles.isEmpty {
            print("❌ Nenhum arquivo de áudio gravado encontrado")
            return nil
        }
        
        let mostRecent = recordedFiles.last
        print("✅ Áudio mais recente: \(mostRecent ?? "nil")")
        return mostRecent
    }
    
    func getRecordedAudiosSortedByDate() -> [String] {
        let documentsPath = getDocumentsDirectory()
        let recordedFiles = getRecordedAudios()
        
        let existingFiles = recordedFiles.compactMap { fileName -> (String, Date)? in
            let filePath = documentsPath.appendingPathComponent(fileName)
            
            guard FileManager.default.fileExists(atPath: filePath.path) else {
                return nil
            }
            
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: filePath.path)
                if let modificationDate = attributes[.modificationDate] as? Date {
                    return (fileName, modificationDate)
                }
            } catch {
                print("Erro ao obter atributos do arquivo: \(error)")
            }
            
            return nil
        }
        
        let sortedFiles = existingFiles.sorted { $0.1 > $1.1 }
        return sortedFiles.map { $0.0 }
    }
}
