# Bitz Eclipse Miner Installer

A single-script solution for setting up and running the Bitz ePOW miner on the Eclipse network.

[Türkçe açıklama için aşağıya bakın 👇](#türkçe-açıklama)

## What is Bitz?

Bitz is the first ePOW (Eclipse Proof-of-Work) token that anyone can mine with just CPU power.

- ⚡️ 5 million maximum supply
- 🔒 No pre-mining or insider allocation
- Token Contract: [64mggk2nXg6vHC1qCdsZdEFzd5QGN4id54Vbho4PswCF](https://eclipsescan.xyz/token/64mggk2nXg6vHC1qCdsZdEFzd5QGN4id54Vbho4PswCF)

## Prerequisites

- A Linux-based system (Ubuntu 20.04+ or WSL on Windows)
- A Backpack wallet (or another Eclipse-compatible wallet)
- 0.005+ ETH on the Eclipse network

## Quick Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/hitasyurekk/bitz-eclipse-installer.git
   cd bitz-eclipse-installer
   ```

2. Make the script executable:
   ```bash
   chmod +x bitz-eclipse-installer.sh
   ```

3. Run the installer:
   ```bash
   ./bitz-eclipse-installer.sh
   ```

4. Follow the prompts to complete the installation.

## What the Installer Does

This script automates the entire setup process:

1. Updates your system and installs required packages
2. Builds and installs Screen from source for session management
3. Installs Rust and the Solana CLI toolchain
4. Configures the Solana CLI for the Eclipse network
5. Creates a new wallet keypair (or uses an existing one)
6. Installs the Bitz miner from source using Cargo
7. Creates convenience scripts for managing your mining operations

## Using the Convenience Scripts

After installation, two scripts will be created in your home directory:

### Start Mining Script
```bash
~/start-bitz-mining.sh
```
This script starts mining with your selected number of CPU cores in a screen session.

### Utility Command Script
```bash
~/bitz-commands.sh [command]
```

Available commands:
- `start` - Start mining in a screen session
- `attach` - Reattach to the mining screen
- `stop` - Stop mining
- `status` - Check if the miner is running
- `claim` - Claim mined tokens
- `account` - Check wallet status

## Important Tips

- To detach from the screen session while keeping the miner running: `CTRL+A+D`
- Always keep a backup of your wallet private key and mnemonic phrase
- Mining only works if your wallet is funded with ETH on the Eclipse network
- For optimal performance, leave at least 1 CPU core free for system operations

## Troubleshooting

- If the Solana CLI commands aren't recognized after installation, try rebooting your system
- If mining fails to start, check that your wallet is properly funded on Eclipse
- For screen session issues, use `screen -ls` to see all active sessions

## License

MIT License

## Author

**Hitasyurek**  
Twitter: [https://x.com/hitasyurek](https://x.com/hitasyurek)

## Contributions

Contributions are welcome! Please feel free to submit a Pull Request.

---

# Türkçe Açıklama

# Bitz Eclipse Madenci Kurulumu

Eclipse ağında Bitz ePOW madencisini kurmak ve çalıştırmak için tek-komutluk çözüm.

## Bitz Nedir?

Bitz, herkesin sadece CPU gücüyle madencilik yapabileceği ilk ePOW (Eclipse İş İspatı) tokenıdır.

- ⚡️ 5 milyon maksimum arz
- 🔒 Ön-madencilik veya içeriden tahsis yok
- Token Sözleşmesi: [64mggk2nXg6vHC1qCdsZdEFzd5QGN4id54Vbho4PswCF](https://eclipsescan.xyz/token/64mggk2nXg6vHC1qCdsZdEFzd5QGN4id54Vbho4PswCF)

## Ön Koşullar

- Linux tabanlı bir sistem (Ubuntu 20.04+ veya Windows'ta WSL)
- Backpack cüzdanı (veya başka bir Eclipse uyumlu cüzdan)
- Eclipse ağında 0.005+ ETH

## Hızlı Kurulum

1. Bu depoyu klonlayın:
   ```bash
   git clone https://github.com/hitasyurekk/bitz-eclipse-installer.git
   cd bitz-eclipse-installer
   ```

2. Komut dosyasını çalıştırılabilir yapın:
   ```bash
   chmod +x bitz-eclipse-installer.sh
   ```

3. Yükleyiciyi çalıştırın:
   ```bash
   ./bitz-eclipse-installer.sh
   ```

4. Kurulumu tamamlamak için talimatları izleyin.

## Bu Yükleyici Ne Yapar?

Bu betik, tüm kurulum sürecini otomatikleştirir:

1. Sisteminizi günceller ve gerekli paketleri yükler
2. Oturum yönetimi için Screen'i kaynaktan derler ve yükler
3. Rust ve Solana CLI araç setini yükler
4. Solana CLI'yi Eclipse ağı için yapılandırır
5. Yeni bir cüzdan anahtar çifti oluşturur (veya mevcut bir tane kullanır)
6. Cargo kullanarak Bitz madencisini kaynaktan yükler
7. Madencilik işlemlerinizi yönetmek için kolaylık betikleri oluşturur

## Kolaylık Betiklerinin Kullanımı

Kurulumdan sonra, ev dizininizde iki betik oluşturulacaktır:

### Madenciliği Başlatma Betiği
```bash
~/start-bitz-mining.sh
```
Bu betik, seçtiğiniz CPU çekirdek sayısıyla bir screen oturumunda madenciliği başlatır.

### Yardımcı Komut Betiği
```bash
~/bitz-commands.sh [komut]
```

Kullanılabilir komutlar:
- `start` - Screen oturumunda madenciliği başlat
- `attach` - Madencilik screen oturumuna tekrar bağlan
- `stop` - Madenciliği durdur
- `status` - Madencinin çalışıp çalışmadığını kontrol et
- `claim` - Madenciliği yapılan tokenleri talep et
- `account` - Cüzdan durumunu kontrol et

## Önemli İpuçları

- Madenciliği çalışır durumda tutarak screen oturumundan ayrılmak için: `CTRL+A+D`
- Her zaman cüzdan özel anahtarınızın ve anımsatıcı ifadenizin yedeğini saklayın
- Madencilik yalnızca cüzdanınız Eclipse ağında ETH ile fonlanmışsa çalışır
- Optimal performans için, sistem işlemleri için en az 1 CPU çekirdeğini boş bırakın

## Sorun Giderme

- Kurulumdan sonra Solana CLI komutları tanınmıyorsa, sisteminizi yeniden başlatmayı deneyin
- Madencilik başlatılamazsa, cüzdanınızın Eclipse'te düzgün şekilde fonlanmış olduğunu kontrol edin
- Screen oturum sorunları için, tüm aktif oturumları görmek için `screen -ls` kullanın

## Lisans

MIT Lisansı

## Yazar

**Hitasyurek**  
Twitter: [https://x.com/hitasyurek](https://x.com/hitasyurek)

## Katkılar

Katkılarınızı memnuniyetle karşılıyoruz! Lütfen Pull Request göndermekten çekinmeyin.
