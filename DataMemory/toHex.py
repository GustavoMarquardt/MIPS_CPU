def calculate_checksum(data_bytes):
    """Calcula o checksum para uma linha Intel Hex."""
    checksum = sum(data_bytes) & 0xFF
    return ((~checksum + 1) & 0xFF)

def generate_hex_file():
    hex_lines = []
    
    # Linha de extensão de endereço (necessária para arquivos Intel Hex válidos)
    hex_lines.append(":020000040000FA")
    
    # Preenche cada endereço de 0 a 31 com o valor do próprio endereço (1 byte por endereço)
    for address in range(0, 32):
        data = [address]  # o dado é o próprio valor do endereço
        data_length = 1  # 1 byte de dados
        record_type = 0x00  # tipo de registro para dados
        
        # Divide o endereço em dois bytes (alto e baixo)
        address_high = (address >> 8) & 0xFF
        address_low = address & 0xFF
        
        # Cria a linha de dados sem o checksum
        data_bytes = [data_length, address_high, address_low, record_type] + data
        
        # Calcula o checksum
        checksum = calculate_checksum(data_bytes)
        
        # Constrói a linha Intel Hex em formato string
        hex_line = f":{data_length:02X}{address_high:02X}{address_low:02X}{record_type:02X}" + "".join(f"{byte:02X}" for byte in data) + f"{checksum:02X}"
        hex_lines.append(hex_line)
    
    # Linha de fim de arquivo
    hex_lines.append(":00000001FF")
    
    return "\n".join(hex_lines)

# Gera e imprime o arquivo Intel Hex
hex_content = generate_hex_file()
print(hex_content)

# Salva em um arquivo
with open("data.hex", "w") as file:
    file.write(hex_content)
