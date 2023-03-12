import bcrypt

def main():

    all_lines = []
    count_encripted_line: int = 0

    with open('guest.sql', 'r') as sql_file:
        while(line := sql_file.readline().rstrip()):
            before_passfrase = line[line.index("'"):].split(',')[1].replace("'", "")[1:]
            nif = line[line.index("'"):].split(',')[5].replace("'", "")[1:]
            telephone = line[line.index("'"):].split(',')[9].replace("'", "")[1:]
            passfrase = bcrypt.hashpw(password=before_passfrase.encode(), salt=bcrypt.gensalt())
            line = line.replace(before_passfrase, passfrase.decode())
            line = line.replace(nif, "'" + nif + "'")
            line = line.replace(telephone, "'" + telephone + "'")

            count_encripted_line += 1
            print(f"{count_encripted_line}: " + line + "\n")
            all_lines.append(line)

    with open('modified-guest.sql', 'w') as sql_file:
        sql_file.writelines(all_lines)

main()