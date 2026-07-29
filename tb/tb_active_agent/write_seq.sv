class wrt_seq extends uvm_sequence #(cpu_tx);

  `uvm_object_utils(cpu_write_seq)

  seq_item req;

  function new(string name="cpu_write_seq");
    super.new(name);
  endfunction

  task body();

    req = seq_item::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      mode ==  0;
      wr_en == 1;
      rd_en == 0;
      strobe == 4'b1111;
    });

    finish_item(req);

  endtask

endclass
