import gleam/io

fn error(f: Bool) -> Result(Int, Nil) {
  case f {
    True -> Error(Nil)
    False -> Ok(2)
  }
}

pub fn main() {
  let assert Ok(ok) = error(True) as "Fuck mate"

  io.debug(ok)

}
