////
//// SQLite.Query
//// Copyright (c) 2014 Stephen Celis.
////
//// Permission is hereby granted, free of charge, to any person obtaining a copy
//// of this software and associated documentation files (the "Software"), to deal
//// in the Software without restriction, including without limitation the rights
//// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//// copies of the Software, and to permit persons to whom the Software is
//// furnished to do so, subject to the following conditions:
////
//// The above copyright notice and this permission notice shall be included in
//// all copies or substantial portions of the Software.
////
//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//// THE SOFTWARE.
////
//
///// A query object. Used to build SQL statements with a collection of chainable
///// helper functions.
//
//
//public struct Query {
//
//    internal var database: Database
//
//    internal init(_ database: Database, _ tableName: String) {
//        self.database = database
//        self.tableName = tableName
//    }
//
//    // MARK: - Keywords
//
//    /// Determines the join operator for a query’s JOIN clause.
//    public enum JoinType: String {
//
//        /// A CROSS JOIN.
//        case Cross = "CROSS"
//
//        /// An INNER JOIN.
//        case Inner = "INNER"
//
//        /// A LEFT OUTER JOIN.
//        case LeftOuter = "LEFT OUTER"
//
//    }
//
//    private var columns: [Expressible] = [Expression<()>(literal: "*")]
//    private var distinct: Bool = false
//    internal var tableName: String
//    private var alias: String?
//    private var joins: [(type: JoinType, table: Query, condition: Expression<Bool>)] = []
//    private var filter: Expression<Bool>?
//    private var group: Expressible?
//    private var order = [Expressible]()
//    private var limit: (to: Int, offset: Int?)? = nil
//
//    public func alias(alias: String?) -> Query {
//        var query = self
//        query.alias = alias
//        return query
//    }
//
//    /// Sets the SELECT clause on the query.
//    ///
//    /// :param: all A list of expressions to select.
//    ///
//    /// :returns: A query with the given SELECT clause applied.
//    public func select(all: Expressible...) -> Query {
//        var query = self
//        (query.distinct, query.columns) = (false, all)
//        return query
//    }
//
//    /// Sets the SELECT DISTINCT clause on the query.
//    ///
//    /// :param: columns A list of expressions to select.
//    ///
//    /// :returns: A query with the given SELECT DISTINCT clause applied.
//    public func select(distinct columns: Expressible...) -> Query {
//        var query = self
//        (query.distinct, query.columns) = (true, columns)
//        return query
//    }
//
//    // rdar://18778670 causes select(distinct: *) to make select(*) ambiguous
//    /// Sets the SELECT clause on the query.
//    ///
//    /// :param: star A literal *.
//    ///
//    /// :returns: A query with SELECT * applied.
//    public func select(all star: Star) -> Query {
//        return select(star(nil, nil))
//    }
//
//    /// Sets the SELECT DISTINCT * clause on the query.
//    ///
//    /// :param: star A literal *.
//    ///
//    /// :returns: A query with SELECT * applied.
//    public func select(distinct star: Star) -> Query {
//        return select(distinct: star(nil, nil))
//    }
//
//    /// Adds an INNER JOIN clause to the query.
//    ///
//    /// :param: table A query representing the other table.
//    ///
//    /// :param: on    A boolean expression describing the join condition.
//    ///
//    /// :returns: A query with the given INNER JOIN clause applied.
//    public func join(table: Query, on: Expression<Bool>) -> Query {
//        return join(.Inner, table, on: on)
//    }
//
//    /// Adds an INNER JOIN clause to the query.
//    ///
//    /// :param: table A query representing the other table.
//    ///
//    /// :param: on    A boolean expression describing the join condition.
//    ///
//    /// :returns: A query with the given INNER JOIN clause applied.
//    public func join(table: Query, on: Expression<Bool?>) -> Query {
//        return join(.Inner, table, on: on)
//    }
//
//    /// Adds a JOIN clause to the query.
//    ///
//    /// :param: type  The JOIN operator.
//    ///
//    /// :param: table A query representing the other table.
//    ///
//    /// :param: on    A boolean expression describing the join condition.
//    ///
//    /// :returns: A query with the given JOIN clause applied.
//    public func join(type: JoinType, _ table: Query, on: Expression<Bool>) -> Query {
//        var query = self
//        let join = (type: type, table: table, condition: table.filter.map { on && $0 } ?? on)
//        query.joins.append(join)
//        return query
//    }
//
//    /// Adds a JOIN clause to the query.
//    ///
//    /// :param: type  The JOIN operator.
//    ///
//    /// :param: table A query representing the other table.
//    ///
//    /// :param: on    A boolean expression describing the join condition.
//    ///
//    /// :returns: A query with the given JOIN clause applied.
//    public func join(type: JoinType, _ table: Query, on: Expression<Bool?>) -> Query {
//        return join(type, table, on: Expression<Bool>(on))
//    }
//
//    /// Adds a condition to the query’s WHERE clause.
//    ///
//    /// :param: condition A boolean expression to filter on.
//    ///
//    /// :returns: A query with the given WHERE clause applied.
//    public func filter(condition: Expression<Bool>) -> Query {
//        var query = self
//        query.filter = filter.map { $0 && condition } ?? condition
//        return query
//    }
//
//    /// Adds a condition to the query’s WHERE clause.
//    ///
//    /// :param: condition A boolean expression to filter on.
//    ///
//    /// :returns: A query with the given WHERE clause applied.
//    public func filter(condition: Expression<Bool?>) -> Query {
//        return filter(Expression<Bool>(condition))
//    }
//
//    /// Sets a GROUP BY clause on the query.
//    ///
//    /// :param: by A list of columns to group by.
//    ///
//    /// :returns: A query with the given GROUP BY clause applied.
//    public func group(by: Expressible...) -> Query {
//        return group(by)
//    }
//
//    /// Sets a GROUP BY clause (with optional HAVING) on the query.
//    ///
//    /// :param: by       A column to group by.
//    ///
//    /// :param: having   A condition determining which groups are returned.
//    ///
//    /// :returns: A query with the given GROUP BY clause applied.
//    public func group(by: Expressible, having: Expression<Bool>) -> Query {
//        return group([by], having: having)
//    }
//
//    /// Sets a GROUP BY clause (with optional HAVING) on the query.
//    ///
//    /// :param: by       A column to group by.
//    ///
//    /// :param: having   A condition determining which groups are returned.
//    ///
//    /// :returns: A query with the given GROUP BY clause applied.
//    public func group(by: Expressible, having: Expression<Bool?>) -> Query {
//        return group([by], having: having)
//    }
//
//    /// Sets a GROUP BY-HAVING clause on the query.
//    ///
//    /// :param: by       A list of columns to group by.
//    ///
//    /// :param: having   A condition determining which groups are returned.
//    ///
//    /// :returns: A query with the given GROUP BY clause applied.
//    public func group(by: [Expressible], having: Expression<Bool>? = nil) -> Query {
//        var query = self
//
//#if iOS7
//        var group = seller.join(" ", [Expression<()>(literal: "GROUP BY"), seller.join(", ", by)])
//
//        if let having = having { group = seller.join(" ", [group, Expression<()>(literal: "HAVING"), having]) }
//#else
//        var group = LinUtil.join(" ", [Expression<()>(literal: "GROUP BY"), LinUtil.join(", ", by)])
//        if let having = having { group = LinUtil.join(" ", [group, Expression<()>(literal: "HAVING"), having]) }
//#endif
//        query.group = group
//        return query
//    }
//
//    /// Sets a GROUP BY-HAVING clause on the query.
//    ///
//    /// :param: by       A list of columns to group by.
//    ///
//    /// :param: having   A condition determining which groups are returned.
//    ///
//    /// :returns: A query with the given GROUP BY clause applied.
//    public func group(by: [Expressible], having: Expression<Bool?>) -> Query {
//        return group(by, having: Expression<Bool>(having))
//    }
//
//    /// Sets an ORDER BY clause on the query.
//    ///
//    /// :param: by An ordered list of columns and directions to sort by.
//    ///
//    /// :returns: A query with the given ORDER BY clause applied.
//    public func order(by: Expressible...) -> Query {
//        var query = self
//        query.order = by
//        return query
//    }
//
//    /// Sets the LIMIT clause (and resets any OFFSET clause) on the query.
//    ///
//    /// :param: to The maximum number of rows to return.
//    ///
//    /// :returns: A query with the given LIMIT clause applied.
//    public func limit(to: Int?) -> Query {
//        return limit(to: to, offset: nil)
//    }
//
//    /// Sets LIMIT and OFFSET clauses on the query.
//    ///
//    /// :param: to     The maximum number of rows to return.
//    ///
//    /// :param: offset The number of rows to skip.
//    ///
//    /// :returns: A query with the given LIMIT and OFFSET clauses applied.
//    public func limit(to: Int, offset: Int) -> Query {
//        return limit(to: to, offset: offset)
//    }
//
//    // prevents limit(nil, offset: 5)
//    private func limit(#to: Int?, offset: Int? = nil) -> Query {
//        var query = self
//        if let to = to {
//            query.limit = (to, offset)
//        } else {
//            query.limit = nil
//        }
//        return query
//    }
//
//    // MARK: - Namespacing
//
//    /// Prefixes a column expression with the query’s table name or alias.
//    ///
//    /// :param: column A column expression.
//    ///
//    /// :returns: A column expression namespaced with the query’s table name or
//    ///           alias.
//    public func namespace<V>(column: Expression<V>) -> Expression<V> {
//        return Expression(literal: "\(quote(identifier: alias ?? tableName)).\(column.SQL)", column.bindings)
//    }
//
//    // FIXME: rdar://18673897 subscript<T>(expression: Expression<V>) -> Expression<V>
//
//    public subscript(column: Expression<Blob>) -> Expression<Blob> { return namespace(column) }
//    public subscript(column: Expression<Blob?>) -> Expression<Blob?> { return namespace(column) }
//
//    public subscript(column: Expression<Bool>) -> Expression<Bool> { return namespace(column) }
//    public subscript(column: Expression<Bool?>) -> Expression<Bool?> { return namespace(column) }
//
//    public subscript(column: Expression<Double>) -> Expression<Double> { return namespace(column) }
//    public subscript(column: Expression<Double?>) -> Expression<Double?> { return namespace(column) }
//
//    public subscript(column: Expression<Int>) -> Expression<Int> { return namespace(column) }
//    public subscript(column: Expression<Int?>) -> Expression<Int?> { return namespace(column) }
//
//    public subscript(column: Expression<String>) -> Expression<String> { return namespace(column) }
//    public subscript(column: Expression<String?>) -> Expression<String?> { return namespace(column) }
//
//    /// Prefixes a star with the query’s table name or alias.
//    ///
//    /// :param: star A literal *.
//    ///
//    /// :returns: A * expression namespaced with the query’s table name or
//    ///           alias.
//    public subscript(star: Star) -> Expression<()> {
//        return namespace(star(nil, nil))
//    }
//
//    // MARK: - Compiling Statements
//
//    internal var selectStatement: Statement {
//        let expression = selectExpression
//        return database.prepare(expression.SQL, expression.bindings)
//    }
//
//    internal var selectExpression: Expression<()> {
//        var expressions = [selectClause]
//        joinClause.map(expressions.append)
//        whereClause.map(expressions.append)
//        group.map(expressions.append)
//        orderClause.map(expressions.append)
//        limitClause.map(expressions.append)
//#if iOS7
//        return seller.join(" ", expressions)
//#else
//        return LinUtil.join(" ", expressions)
//#endif
//    }
//
//    /// ON CONFLICT resolutions.
//    public enum OnConflict: String {
//
//        case Replace = "REPLACE"
//
//        case Rollback = "ROLLBACK"
//
//        case Abort = "ABORT"
//
//        case Fail = "FAIL"
//
//        case Ignore = "IGNORE"
//
//    }
//
//    private func insertStatement(values: [Setter], or: OnConflict? = nil) -> Statement {
//        var insertClause = "INSERT"
//        if let or = or { insertClause = "\(insertClause) OR \(or.rawValue)" }
//        var expressions: [Expressible] = [Expression<()>(literal: "\(insertClause) INTO \(quote(identifier: tableName))")]
//#if iOS7
//        let (c, v) = (seller.join(", ", values.map { $0.0 }), seller.join(", ", values.map { $0.1 }))
//        expressions.append(Expression<()>(literal: "(\(c.SQL)) VALUES (\(v.SQL))", c.bindings + v.bindings))
//    
//        whereClause.map(expressions.append)
//        let expression = seller.join(" ", expressions)
//    
//#else
//        let (c, v) = (LinUtil.join(", ", values.map { $0.0 }), LinUtil.join(", ", values.map { $0.1 }))
//        expressions.append(Expression<()>(literal: "(\(c.SQL)) VALUES (\(v.SQL))", c.bindings + v.bindings))
//    
//        whereClause.map(expressions.append)
//        let expression = LinUtil.join(" ", expressions)
//#endif
//        return database.prepare(expression.SQL, expression.bindings)
//    }
//
//    private func updateStatement(values: [Setter]) -> Statement {
//        var expressions: [Expressible] = [Expression<()>(literal: "UPDATE \(quote(identifier: tableName)) SET")]
//#if iOS7
//        expressions.append(seller.join(", ", values.map { seller.join(" = ", [$0, $1]) }))
//        whereClause.map(expressions.append)
//        let expression = seller.join(" ", expressions)
//#else
//        expressions.append(LinUtil.join(", ", values.map { LinUtil.join(" = ", [$0, $1]) }))
//        whereClause.map(expressions.append)
//        let expression = LinUtil.join(" ", expressions)
//#endif
//        return database.prepare(expression.SQL, expression.bindings)
//    }
//
//    private var deleteStatement: Statement {
//        var expressions: [Expressible] = [Expression<()>(literal: "DELETE FROM \(quote(identifier: tableName))")]
//        whereClause.map(expressions.append)
//#if iOS7
//        let expression = seller.join(" ", expressions)
//#else
//        let expression = LinUtil.join(" ", expressions)
//#endif
//        return database.prepare(expression.SQL, expression.bindings)
//    }
//
//    // MARK: -
//
//    private var selectClause: Expressible {
//        var expressions: [Expressible] = [Expression<()>(literal: "SELECT")]
//        if distinct { expressions.append(Expression<()>(literal: "DISTINCT")) }
//#if iOS7
//        expressions.append(seller.join(", ", columns))
//        expressions.append(Expression<()>(literal: "FROM \(self)"))
//        return seller.join(" ", expressions)
//#else
//        expressions.append(LinUtil.join(", ", columns))
//        expressions.append(Expression<()>(literal: "FROM \(self)"))
//        return LinUtil.join(" ", expressions)
//#endif
//    }
//
//    private var joinClause: Expressible? {
//        if joins.count == 0 { return nil }
//#if iOS7
//        return seller.join(" ", joins.map { type, table, condition in
//            Expression<()>(literal: "\(type.rawValue) JOIN \(table) ON \(condition.SQL)", condition.bindings)
//        })
//#else
//        return LinUtil.join(" ", joins.map { type, table, condition in
//            Expression<()>(literal: "\(type.rawValue) JOIN \(table) ON \(condition.SQL)", condition.bindings)
//        })
//#endif
//    }
//
//    internal var whereClause: Expressible? {
//        if let filter = filter {
//            return Expression<()>(literal: "WHERE \(filter.SQL)", filter.bindings)
//        }
//        return nil
//    }
//
//    private var orderClause: Expressible? {
//        if order.count == 0 { return nil }
//#if iOS7
//        let clause = seller.join(", ", order)
//#else
//        let clause = LinUtil.join(", ", order)
//#endif
//        return Expression<()>(literal: "ORDER BY \(clause.SQL)", clause.bindings)
//    }
//
//    private var limitClause: Expressible? {
//        if let limit = limit {
//            var clause = Expression<()>(literal: "LIMIT \(limit.to)")
//            if let offset = limit.offset {
//#if iOS7
//                clause = seller.join(" ", [clause, Expression<()>(literal: "OFFSET \(offset)")])
//#else
//                clause = LinUtil.join(" ", [clause, Expression<()>(literal: "OFFSET \(offset)")])
//#endif
//            }
//            return clause
//        }
//        return nil
//    }
//
//    // MARK: - Array
//
//    /// The first result (or nil if the query has no results).
//    public var first: Row? {
//        var generator = limit(1).generate()
//        return generator.next()
//    }
//
//    /// Returns true if the query has no results.
//    public var isEmpty: Bool { return first == nil }
//
//    // MARK: - Modifying
//
//    /// Runs an INSERT statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The statement.
//    public func insert(value: Setter, _ more: Setter...) -> Statement { return insert([value] + more).statement }
//
//    /// Runs an INSERT statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The row ID.
//    public func insert(value: Setter, _ more: Setter...) -> Int? { return insert([value] + more).ID }
//
//    /// Runs an INSERT statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The row ID and statement.
//    public func insert(value: Setter, _ more: Setter...) -> (ID: Int?, statement: Statement) {
//        return insert([value] + more)
//    }
//
//    private func insert(values: [Setter]) -> (ID: Int?, statement: Statement) {
//        let statement = insertStatement(values).run()
//        return (statement.failed ? nil : database.lastID, statement)
//    }
//
//    public func insert(query: Query) -> Int? { return insert(query).changes }
//
//    public func insert(query: Query) -> Statement { return insert(query).statement }
//
//    public func insert(query: Query) -> (changes: Int?, statement: Statement) {
//        let expression = query.selectExpression
//        let statement = database.run("INSERT INTO \(quote(identifier: tableName)) \(expression.SQL)", expression.bindings)
//        return (statement.failed ? nil : database.lastChanges, statement)
//    }
//
//    public func insert() -> Int? { return insert().ID }
//
//    public func insert() -> Statement { return insert().statement }
//
//    public func insert() -> (ID: Int?, statement: Statement) {
//        let statement = database.run("INSERT INTO \(quote(identifier: tableName)) DEFAULT VALUES")
//        return (statement.failed ? nil : database.lastID, statement)
//    }
//
//    /// Runs a REPLACE statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The statement.
//    public func replace(values: Setter...) -> Statement { return replace(values).statement }
//
//    /// Runs a REPLACE statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The row ID.
//    public func replace(values: Setter...) -> Int? { return replace(values).ID }
//
//    /// Runs a REPLACE statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The row ID and statement.
//    public func replace(values: Setter...) -> (ID: Int?, statement: Statement) {
//        return replace(values)
//    }
//
//    private func replace(values: [Setter]) -> (ID: Int?, statement: Statement) {
//        let statement = insertStatement(values, or: .Replace).run()
//        return (statement.failed ? nil : database.lastID, statement)
//    }
//
//    /// Runs an UPDATE statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The statement.
//    public func update(values: Setter...) -> Statement { return update(values).statement }
//
//    /// Runs an UPDATE statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The number of updated rows.
//    public func update(values: Setter...) -> Int? { return update(values).changes }
//
//    /// Runs an UPDATE statement against the query.
//    ///
//    /// :param: values A list of values to set.
//    ///
//    /// :returns: The number of updated rows and statement.
//    public func update(values: Setter...) -> (changes: Int?, statement: Statement) {
//        return update(values)
//    }
//
//    private func update(values: [Setter]) -> (changes: Int?, statement: Statement) {
//        let statement = updateStatement(values).run()
//        return (statement.failed ? nil : database.lastChanges, statement)
//    }
//
//    /// Runs a DELETE statement against the query.
//    ///
//    /// :returns: The statement.
//    public func delete() -> Statement { return delete().statement }
//
//    /// Runs a DELETE statement against the query.
//    ///
//    /// :returns: The number of deleted rows.
//    public func delete() -> Int? { return delete().changes }
//
//    /// Runs a DELETE statement against the query.
//    ///
//    /// :returns: The number of deleted rows and statement.
//    public func delete() -> (changes: Int?, statement: Statement) {
//        let statement = deleteStatement.run()
//        return (statement.failed ? nil : database.lastChanges, statement)
//    }
//
//    // MARK: - Aggregate Functions
//
//    /// Runs count(*) against the query and returns it.
//    public var count: Int { return count(Expression<()>(literal: "*")) }
//
//    /// Runs count() against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The number of rows matching the given column.
//    public func count<V>(column: Expression<V>) -> Int {
//#if iOS7
//        return calculate(seller.count(column))!
//#else
//        return calculate(LinUtil.count(column))!
//#endif
//    }
//
//    /// Runs count() with DISTINCT against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The number of rows matching the given column.
//    public func count<V>(distinct column: Expression<V>) -> Int {
//#if iOS7
//        return calculate(seller.count(distinct: column))!
//#else
//        return calculate(LinUtil.count(distinct: column))!
//#endif
//    }
//
//    /// Runs count(DISTINCT *) against the query.
//    ///
//    /// :param: star A literal *.
//    ///
//    /// :returns: The number of rows matching the given column.
//    public func count<V>(distinct star: Star) -> Int {
//#if iOS7
//        return calculate(seller.count(distinct: star(nil, nil)))!
//#else
//        return calculate(LinUtil.count(distinct: star(nil, nil)))!
//#endif
//    }
//
//    /// Runs max() against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The largest value of the given column.
//    public func max<V: Value where V.Datatype: Comparable>(column: Expression<V>) -> V? {
//#if iOS7
//        return calculate(seller.max(column))
//#else
//        return calculate(LinUtil.max(column))
//#endif
//    }
//    public func max<V: Value where V.Datatype: Comparable>(column: Expression<V?>) -> V? {
//#if iOS7
//        return calculate(seller.max(column))
//#else
//        return calculate(LinUtil.max(column))
//#endif
//    }
//
//    /// Runs min() against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The smallest value of the given column.
//    public func min<V: Value where V.Datatype: Comparable>(column: Expression<V>) -> V? {
//#if iOS7
//        return calculate(seller.min(column))
//#else
//        return calculate(LinUtil.min(column))
//#endif
//    }
//    public func min<V: Value where V.Datatype: Comparable>(column: Expression<V?>) -> V? {
//#if iOS7
//        return calculate(seller.min(column))
//#else
//        return calculate(LinUtil.min(column))
//#endif
//    }
//
//    /// Runs avg() against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The average value of the given column.
//    public func average<V: Number>(column: Expression<V>) -> Double? {
//#if iOS7
//        return calculate(seller.average(column))
//#else
//        return calculate(LinUtil.average(column))
//#endif
//    }
//    public func average<V: Number>(column: Expression<V?>) -> Double? {
//#if iOS7
//        return calculate(seller.average(column))
//#else
//        return calculate(LinUtil.average(column))
//#endif
//    }
//
//    /// Runs avg() with DISTINCT against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The average value of the given column.
//    public func average<V: Number>(distinct column: Expression<V>) -> Double? {
//#if iOS7
//        return calculate(seller.average(distinct: column))
//#else
//        return calculate(LinUtil.average(distinct: column))
//#endif
//    }
//    public func average<V: Number>(distinct column: Expression<V?>) -> Double? {
//#if iOS7
//        return calculate(seller.average(distinct: column))
//#else
//        return calculate(LinUtil.average(distinct: column))
//#endif
//    }
//
//    /// Runs sum() against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The sum of the given column’s values.
//    public func sum<V: Number>(column: Expression<V>) -> V? {
//#if iOS7
//        return calculate(seller.sum(column))
//#else
//        return calculate(LinUtil.sum(column))
//#endif
//    }
//    public func sum<V: Number>(column: Expression<V?>) -> V? {
//#if iOS7
//        return calculate(seller.sum(column))
//#else
//        return calculate(LinUtil.sum(column))
//#endif
//    }
//
//    /// Runs sum() with DISTINCT against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The sum of the given column’s values.
//    public func sum<V: Number>(distinct column: Expression<V>) -> V? {
//#if iOS7
//        return calculate(seller.sum(distinct: column))
//#else
//        return calculate(LinUtil.sum(distinct: column))
//#endif
//    }
//    public func sum<V: Number>(distinct column: Expression<V?>) -> V? {
//#if iOS7
//        return calculate(seller.sum(distinct: column))
//#else
//        return calculate(LinUtil.sum(distinct: column))
//#endif
//    }
//
//    /// Runs total() against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The total of the given column’s values.
//    public func total<V: Number>(column: Expression<V>) -> Double {
//#if iOS7
//        return calculate(seller.total(column))!
//#else
//        return calculate(LinUtil.total(column))!
//#endif
//    }
//    public func total<V: Number>(column: Expression<V?>) -> Double {
//#if iOS7
//        return calculate(seller.total(column))!
//#else
//        return calculate(LinUtil.total(column))!
//#endif
//    }
//
//    /// Runs total() with DISTINCT against the query.
//    ///
//    /// :param: column The column used for the calculation.
//    ///
//    /// :returns: The total of the given column’s values.
//    public func total<V: Number>(distinct column: Expression<V>) -> Double {
//#if iOS7
//        return calculate(seller.total(distinct: column))!
//#else
//        return calculate(LinUtil.total(distinct: column))!
//#endif
//    }
//    public func total<V: Number>(distinct column: Expression<V?>) -> Double {
//#if iOS7
//        return calculate(seller.total(distinct: column))!
//#else
//        return calculate(LinUtil.total(distinct: column))!
//#endif
//    }
//
//    private func calculate<T, U>(expression: Expression<T>) -> U? {
//        return select(expression).selectStatement.scalar() as? U
//    }
//
//}
//
///// A row object. Returned by iterating over a Query. Provides typed subscript
///// access to a row’s values.
//public struct Row {
//
//    private let columnNames: [String: Int]
//    private let values: [Binding?]
//
//    private init(_ columnNames: [String: Int], _ values: [Binding?]) {
//        (self.columnNames, self.values) = (columnNames, values)
//    }
//
//    /// Returns a row’s value for the given column.
//    ///
//    /// :param: column An expression representing a column selected in a Query.
//    ///
//    /// returns The value for the given column.
//    public func get<V: Value where V.Datatype: Binding>(column: Expression<V>) -> V {
//        return get(Expression<V?>(column))!
//    }
//    public func get<V: Value where V.Datatype: Binding>(column: Expression<V?>) -> V? {
//        func valueAtIndex(idx: Int) -> V? {
//            if let value = values[idx] as? V.Datatype { return (V.fromDatatypeValue(value) as! V) }
//            return nil
//        }
//
//        if let idx = columnNames[column.SQL] { return valueAtIndex(idx) }
//
//        let similar = filter(columnNames.keys) { $0.hasSuffix(".\(column.SQL)") }
//        if similar.count == 1 { return valueAtIndex(columnNames[similar[0]]!) }
//
//        if similar.count > 1 {
//            fatalError("ambiguous column \(quote(literal: column.SQL)) (please disambiguate: \(similar))")
//        }
//        fatalError("no such column \(quote(literal: column.SQL)) in columns: \(Array(columnNames.keys))")
//    }
//
//    // FIXME: rdar://18673897 subscript<T>(expression: Expression<V>) -> Expression<V>
//
//    public subscript(column: Expression<Blob>) -> Blob { return get(column) }
//    public subscript(column: Expression<Blob?>) -> Blob? { return get(column) }
//
//    public subscript(column: Expression<Bool>) -> Bool { return get(column) }
//    public subscript(column: Expression<Bool?>) -> Bool? { return get(column) }
//
//    public subscript(column: Expression<Double>) -> Double { return get(column) }
//    public subscript(column: Expression<Double?>) -> Double? { return get(column) }
//
//    public subscript(column: Expression<Int>) -> Int { return get(column) }
//    public subscript(column: Expression<Int?>) -> Int? { return get(column) }
//
//    public subscript(column: Expression<String>) -> String { return get(column) }
//    public subscript(column: Expression<String?>) -> String? { return get(column) }
//
//}
//
//// MARK: - SequenceType
//extension Query: SequenceType {
//
//    public typealias Generator = QueryGenerator
//
//    public func generate() -> Generator { return Generator(self) }
//
//}
//
//// MARK: - GeneratorType
//public struct QueryGenerator: GeneratorType {
//
//    private let query: Query
//    private let statement: Statement
//
//    private lazy var columnNames: [String: Int] = {
//        var (columnNames, idx) = ([String: Int](), 0)
//        for each in self.query.columns {
//            let pair = split(each.expression.SQL) { $0 == "." }
//            let (tableName, column) = (pair.count > 1 ? pair.first : nil, pair.last!)
//
//            func expandGlob(namespace: Bool) -> Query -> () {
//                return { table in
//                    var names = self.query.database[table.tableName].selectStatement.columnNames.map { quote(identifier: $0) }
//                    if namespace { names = names.map { "\(quote(identifier: table.alias ?? table.tableName)).\($0)" } }
//                    for name in names { columnNames[name] = idx++ }
//                }
//            }
//
//            if column == "*" {
//                if let tableName = tableName {
//                    expandGlob(true)(self.query.database[tableName])
//                    continue
//                }
//                let tables = [self.query] + self.query.joins.map { $0.table }
//                tables.map(expandGlob(self.query.joins.count > 0))
//                continue
//            }
//
//            columnNames[each.expression.SQL] = idx++
//        }
//        return columnNames
//    }()
//
//    private init(_ query: Query) {
//        (self.query, self.statement) = (query, query.selectStatement)
//    }
//
//    public mutating func next() -> Row? {
//        return statement.next().map { Row(self.columnNames, $0) }
//    }
//
//}
//
//// MARK: - Printable
//extension Query: Printable {
//
//    public var description: String {
//        if let alias = alias { return "\(quote(identifier: tableName)) AS \(quote(identifier: alias))" }
//        return quote(identifier: tableName)
//    }
//
//}
//
//extension Database {
//
//    public subscript(tableName: String) -> Query {
//        return Query(self, tableName)
//    }
//
//}
