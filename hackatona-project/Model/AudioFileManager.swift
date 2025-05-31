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
            print("💾 Áudio salvo: \(fileName)")
            print("📋 Total de áudios salvos: \(savedAudios.count)")
        } else {
            print("⚠️ Áudio já existe na lista: \(fileName)")
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
        
        print("🔍 Verificando arquivo: \(fileName)")
        print("📁 Caminho completo: \(filePath.path)")
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            print("✅ Arquivo existe!")
            
            // Verificar tamanho do arquivo
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
    
    // MARK: - Get most recent recorded audio
    func getMostRecentRecordedAudio() -> String? {
        let recordedFiles = getRecordedAudios()
        
        print("🔍 Buscando áudio mais recente...")
        print("📋 Arquivos gravados disponíveis: \(recordedFiles)")
        
        // Se não temos arquivos gravados, retorna nil
        if recordedFiles.isEmpty {
            print("❌ Nenhum arquivo de áudio gravado encontrado")
            return nil
        }
        
        // Retorna o último arquivo gravado (mais recente)
        let mostRecent = recordedFiles.last
        print("✅ Áudio mais recente: \(mostRecent ?? "nil")")
        return mostRecent
    }
    
    // MARK: - Get all recorded audios sorted by date
    func getRecordedAudiosSortedByDate() -> [String] {
        let documentsPath = getDocumentsDirectory()
        let recordedFiles = getRecordedAudios()
        
        // Filtrar apenas arquivos que realmente existem e ordenar por data de modificação
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
        
        // Ordenar por data de modificação (mais recente primeiro)
        let sortedFiles = existingFiles.sorted { $0.1 > $1.1 }
        return sortedFiles.map { $0.0 }
    }
}
