
`define my_always(temp, a, b, y) \
always @(*) begin \
    temp = a*b;   \
    y = a + temp; \
end
