# Toy

Interview project.

## Requirements

- Case 1:

  ```text
  Implement in Ruby on Rails, for the following problem:  model employees and contracts in a bitemporal database.

  Models and attributes
  * An Employee has a first_name (String), a last_name (String), a birth date (Date), and an address (multi-line text).
  * A Contract has a start_date (Date), an end_date (Date), and a legal entity. In real life a legal entity would be a separate model, but for this assignment, we will keep things simple and use a String.
  * All the attributes of the Employee and Contract models are bitemporal.
  Relationships
  Employees can have multiple contracts in time, but their contract periods do not overlap.

  Create a Ruby on Rails project. We will use the rails console to perform some experiments.
  Write a migration for employees.
  Write a migration for contracts.
  Add all the required classes.
  Add a class/method to query all employees with a current contract, given some search criteria based on employee and contract attributes. ***
  Use test-driven development.

  You find the bitemporal plugin at https://github.com/TalentBox/sequel_bitemporal. It is a public repo.

  The most important part of the exercise is marked with ***.
  ```

- Case 2:

  ```text
  1. 基于上面的项目代码创建一个带搜索的列表页，展示所有employee。
  2. 从列表页点一个employee，进入employee详情页，详情页需要有一个选日期的控件，选不同日期后，详情页根据选的日期展示对应日期的数据状态
  3. 在详情页可以编辑数据并保存，保存的数据的有效期要基于页面的日期来确定，比如选的日期是2022-01-01，那么保存的数据生效期是从2022-01-01开始。
  4. 关于bitemporal可以参考https://github.com/TalentBox/sequel_bitemporal/blob/master/spec/bitemporal_date_spec.rb 里面的测试描述。

  以下是供参考的employee列表页和详情页，截图里的比较复杂，字段比较多，测试里不需要这么多字段。
  ```

## Run

```sh
$ ruby -v
> ruby 2.7.2
$ rails
> Rails 6.1.4.6
$ bundle
$ yarn
$ rails db:create db:migrate db:seed
$ rails s
# visit localhost:3000
```

## Test

```sh
> rails db:test:prepare
> rspec
...
> rails c
# all employees with current contract
> Employee.join_contracts.all
# avoid N+1 query
> Employee.eager_contracts.all
# query by contract's legal
> Employee.by_legal('Leader').all
```
