#!/usr/bin/env python3
import argparse

def remove_range_from_fasta(input_file, output_file, start_position, end_position):
    sequences = []
    current_sequence = None

    # Read the input file and store the sequences
    with open(input_file, 'r') as file:
        for line in file:
            line = line.strip()

            if line.startswith('>'):
                # Start of a new sequence
                if current_sequence is not None:
                    sequences.append(current_sequence)
                current_sequence = {'header': line, 'sequence': ''}
            else:
                # Append sequence line
                current_sequence['sequence'] += line

        if current_sequence is not None:
            sequences.append(current_sequence)

    # Remove the specified range of positions from each sequence
    for sequence in sequences:
        start_index = start_position - 1
        end_index = end_position
        sequence['sequence'] = sequence['sequence'][:start_index] + sequence['sequence'][end_index:]

    # Write the modified sequences to the output file
    with open(output_file, 'w') as file:
        for sequence in sequences:
            file.write(sequence['header'] + '\n')
            file.write(sequence['sequence'] + '\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove a range of positions from a FASTA file.")
    parser.add_argument("input_file", help="Input FASTA file")
    parser.add_argument("output_file", help="Output FASTA file")
    parser.add_argument("start_position", type=int, help="Start position of the range to remove")
    parser.add_argument("end_position", type=int, help="End position of the range to remove")

    args = parser.parse_args()

    remove_range_from_fasta(args.input_file, args.output_file, args.start_position, args.end_position)