gpa_calc = function(data) {
  data |>
    mutate(n = A   +
             'A-' +
             'B+' +
             B   +
             'B-' +
             'C+' +
             C   +
             'C-' +
             'D+' +
             D   +
             'D-' +
             F) |>
    mutate(points = (4.0 *  A )  +
             (3.8 * 'A-') +
             (3.4 * 'B+') +
             (3.1 *  B)   + 
             (2.8 * 'B-') +
             (2.4 * 'C+') +
             (2.1 *  C)   +
             (1.8 * 'C-') +
             (1.4 * 'D+') +
             (1.1 *  D)   + 
             (0.8 * 'D-') +
             (0.0 *  F)) |>
    mutate(GPA = round(points / n, digits = 1)) |>
    select(-n, -points)
}